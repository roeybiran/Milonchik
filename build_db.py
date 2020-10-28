#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import sqlite3
import os

dirname = os.path.dirname(os.path.realpath(__file__))
db_file = os.path.join(dirname, "milon.db")

if os.path.exists(db_file):
    os.remove(db_file)

connection = sqlite3.connect(db_file)

with connection:
    cursor = connection.cursor()

    create_table_statements = [
        'CREATE TABLE IF NOT EXISTS definitions(id INTEGER PRIMARY KEY, input_lang TEXT, input_word TEXT, sanitized_input_word TEXT, part_of_speech TEXT);',
        'CREATE TABLE IF NOT EXISTS synonyms(id INTEGER NOT NULL, synonym TEXT, FOREIGN KEY (id) REFERENCES definitions(id));',
        'CREATE TABLE IF NOT EXISTS translations(id INTEGER NOT NULL, translation TEXT, FOREIGN KEY (id) REFERENCES definitions(id));',
        'CREATE TABLE IF NOT EXISTS samples(id INTEGER NOT NULL, sample TEXT, FOREIGN KEY (id) REFERENCES definitions(id));',
        'CREATE TABLE IF NOT EXISTS inflections(id INTEGER NOT NULL, inflection_kind TEXT, inflection_value TEXT, FOREIGN KEY (id) REFERENCES definitions(id));',
        'CREATE TABLE IF NOT EXISTS alternate_spellings(id INTEGER NOT NULL, spelling TEXT, FOREIGN KEY (id) REFERENCES definitions(id));',
    ]

    for s in create_table_statements:
        cursor.execute(s)

    with open(os.path.join(dirname, "merged.json")) as json_file:
        for word in json.load(json_file):
            id = word["id"]
            translated_lang = word["translated_lang"]
            translated_word = word["translated"]
            translated_word_sanitized = word["translated_sanitized"]
            part_of_speech = word["part_of_speech"]
            synonyms = word["synonyms"]
            translations = word["translation"]
            samples = word["samples"]
            inflections = word["inflections"]
            alt_spellings = word["alternate_spellings"]

            cursor.execute(
                'INSERT INTO definitions(id, input_lang, input_word, sanitized_input_word, part_of_speech) VALUES(?, ?, ?, ?, ?);',
                (id, translated_lang, translated_word, translated_word_sanitized, part_of_speech))

            for syn in synonyms:
                cursor.execute('INSERT INTO synonyms(id, synonym) VALUES(?, ?);',
                               (id, syn))

            for trans in translations:
                cursor.execute(
                    'INSERT INTO translations(id, translation) VALUES(?, ?);',
                    (id, trans))

            for sample in samples:
                cursor.execute(
                    'INSERT INTO samples(id, sample) VALUES(?, ?);', (id, sample))

            for inflection in inflections:
                inflection_kind = inflection["Title"]
                inflection_text = inflection["Text"]
                cursor.execute(
                    'INSERT INTO inflections(id, inflection_kind, inflection_value) VALUES(?, ?, ?);',
                    (id, inflection_kind, inflection_text))

            for alt in alt_spellings:
                cursor.execute(
                    'INSERT INTO alternate_spellings(id, spelling) VALUES(?, ?);',
                    (id, alt))

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
  {
    "part_of_speech": "abbreviation",
    "synonyms": [],
    "samples": [],
    "translated": "approx.",
    "translation": [
      "בְּקֵרוּב"
    ],
    "inflections": [],
    "id": 2990,
    "translated_lang": "eng",
    "translated_sanitized": "approx.",
    "alternate_spellings": []
  },
 """
