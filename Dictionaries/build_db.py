#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import sqlite3
import os

dirname = os.path.dirname(os.path.realpath(__file__))
db_file = os.path.join(dirname, "milon.db")
SEPARATOR = "\t"

columns = [
    {"name": "id", "type": "INTEGER PRIMARY KEY"},
    {"name": "translated_lang", "type": "TEXT"},
    {"name": "translated_word", "type": "TEXT"},
    {"name": "translated_word_sanitized", "type": "TEXT"},
    {"name": "part_of_speech", "type": "TEXT"},
    {"name": "synonyms", "type": "TEXT"},
    {"name": "translations", "type": "TEXT"},
    {"name": "samples", "type": "TEXT"},
    {"name": "inflection_kind", "type": "TEXT"},
    {"name": "inflection_value", "type": "TEXT"},
    {"name": "alternate_spellings", "type": "TEXT"},
]

if os.path.exists(db_file):
    os.remove(db_file)

connection = sqlite3.connect(db_file)
cursor = connection.cursor()

create_table_stmt = "CREATE TABLE definitions({});".format(", ".join(
    map(lambda x: x["name"] + " " + x["type"], columns)))
cursor.execute(create_table_stmt)
json_file = open(os.path.join(dirname, "merged.json"))
json_obj = json.load(json_file)
i = 1
for word in json_obj:
    print("{} out of {}".format(i, len(json_obj)))
    i += 1
    id = word["id"]
    translated_lang = word["translated_lang"]
    translated_word = word["translated"]
    translated_word_sanitized = word["translated_sanitized"]
    part_of_speech = word["part_of_speech"]
    synonyms = SEPARATOR.join(word["synonyms"])
    translations = SEPARATOR.join(word["translation"])
    samples = SEPARATOR.join(word["samples"])
    inflection_kind = SEPARATOR.join(
        map(lambda x: x["Title"], word["inflections"]))
    inflection_value = SEPARATOR.join(
        map(lambda x: x["Text"], word["inflections"]))
    alternate_spellings = SEPARATOR.join(word["alternate_spellings"])

    column_names = ", ".join(map(lambda x: x["name"], columns))
    question_marks = ", ".join(["?" for _ in columns])
    stmt = "INSERT INTO definitions({}) VALUES({});".format(
        column_names, question_marks)
    cursor.execute(stmt, (id,  translated_lang,  translated_word,  translated_word_sanitized,
                          part_of_speech,  synonyms,  translations,  samples,  inflection_kind,  inflection_value,  alternate_spellings))
    connection.commit()

json_file.close()
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
