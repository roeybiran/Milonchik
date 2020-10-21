#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import json
import sqlite3
import os

dirname = os.path.dirname(os.path.realpath(__file__))
db_file = os.path.join(dirname, "milon.db")

if os.path.exists(db_file):
    os.remove(db_file)

dicts = ["dict-en-he.json", "dict-he-en.json"]
all_words = []
for dict in dicts:
    with open(os.path.join(dirname, dict)) as json_file:
        words = json.load(json_file)
        for word in words:
            word["input_lang"] = "eng" if dict.endswith(
                "dict-en-he.json") else "heb"
        all_words.extend(words)

connection = sqlite3.connect(db_file)
with connection:
    cursor = connection.cursor()

    create_table_statements = [
        'CREATE TABLE IF NOT EXISTS definitions(id INTEGER PRIMARY KEY, input_lang TEXT, input_word TEXT, sanitized_input_word TEXT, part_of_speech TEXT);',
        'CREATE TABLE IF NOT EXISTS synonyms(id INTEGER NOT NULL, synonym TEXT, FOREIGN KEY (id) REFERENCES definitions(id));',
        'CREATE TABLE IF NOT EXISTS translations(id INTEGER NOT NULL, translation TEXT, FOREIGN KEY (id) REFERENCES definitions(id));',
        'CREATE TABLE IF NOT EXISTS samples(id INTEGER NOT NULL, sample TEXT, FOREIGN KEY (id) REFERENCES definitions(id));',
        'CREATE TABLE IF NOT EXISTS inflections(id INTEGER NOT NULL, inflection_kind TEXT, inflection_value TEXT, FOREIGN KEY (id) REFERENCES definitions(id));',
    ]

    for s in create_table_statements:
        cursor.execute(s)

    for idx, word in enumerate(all_words):
        id = idx + 1
        input_lang = word["input_lang"]
        input_word = word["translated"]
        # remove niqqud, diacritics
        sanitized_input_word = re.sub(pattern=u"[\u0591-\u05C7]",
                                      repl="",
                                      string=input_word,
                                      count=0,
                                      flags=re.IGNORECASE)
        part_of_speech = None if (
            len(word["part_of_speech"]) == 0) else word["part_of_speech"]
        cursor.execute(
            'INSERT INTO definitions(id, input_lang, input_word, sanitized_input_word, part_of_speech) VALUES(?, ?, ?, ?, ?);',
            (id, input_lang, input_word, sanitized_input_word, part_of_speech))
        for syn in word["synonyms"]:
            cursor.execute('INSERT INTO synonyms(id, synonym) VALUES(?, ?);',
                           (id, syn))
        for trans in word["translation"]:
            cursor.execute(
                'INSERT INTO translations(id, translation) VALUES(?, ?);',
                (id, trans))
        for sample in word["samples"]:
            cursor.execute('INSERT INTO samples(id, sample) VALUES(?, ?);',
                           (id, sample))
        for inflection in word["inflections"]:
            inflection_kind = inflection["Title"]
            inflection_text = inflection["Text"]
            cursor.execute(
                'INSERT INTO inflections(id, inflection_kind, inflection_value) VALUES(?, ?, ?);',
                (id, inflection_kind, inflection_text))

connection.close()

# json definition looks like this:
"""
  {
    "part_of_speech": "noun",
    "synonyms": [],
    "samples": [
      "the <b>wrath</b> of the gods",
      "waited until my initial <b>wrath</b> had eased before voicing my complaint"
    ],
    "translated": "wrath",
    "translation": [
      "זַעַם",
      "חָרוֹן",
      "חֵמָה"
    ],
    "inflections": [
      {
        "Text": "wraths",
        "Code": "33",
        "Title": "רבים"
      }
    ],
    "id": "108215"
  },
 """
