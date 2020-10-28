#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# WARNING
# script is naive and extremely slow - takes over 1 hour to complete
# and that's when skipping the english dictionary, (which is twice as large as the hebrew one)
#

import re
import json
import os
import sys

try:
    import Levenshtein
except ImportError as e:
    print(str(e) + ". Aborting.")
    sys.exit()

dirname = os.path.dirname(os.path.realpath(__file__))
spellings_file = os.path.join(dirname, "hebrew_alternate_spellings.txt")
dicts = ["dict-en-he.json", "dict-he-en.json"]
ahvi = ["י", "ו"]
all_words = []
alternate_spellings = []

with open(spellings_file) as wordsfile:
    for line in wordsfile.readlines():
        line = line.lstrip().rstrip()
        alternate_spellings.append(line)

total_index = 0
for dict_index, dict in enumerate(dicts):
    with open(os.path.join(dirname, dict)) as json_file:
        words = json.load(json_file)
        for word_index, word in enumerate(words):
            translated_lang = "eng" if dict.endswith(
                "dict-en-he.json") else "heb"
            translated = word["translated"]
            # remove niqqud, diacritics
            translated_sanitized = re.sub(pattern=u"[\u0591-\u05C7]",
                                                  repl="",
                                                  string=translated,
                                                  count=0,
                                                  flags=re.IGNORECASE)
            word_alternate_spellings = []

            if translated_lang == "heb":
                for alt in alternate_spellings:
                    dist = Levenshtein.distance(alt, translated_sanitized)
                    if dist == 1:
                        edit_op = Levenshtein.editops(
                            alt, translated_sanitized)
                        if edit_op[0][0] == "delete":
                            if (alt[edit_op[0][1]]) in ahvi:
                                word_alternate_spellings.append(alt)
                                print("dict: {}/{}, word: {}/{}".format(dict_index +
                                                                        1, len(dicts), word_index + 1, len(words)))
            word["translated_lang"] = translated_lang
            word["id"] = total_index
            word["translated_sanitized"] = translated_sanitized
            word["alternate_spellings"] = word_alternate_spellings
            all_words.append(word)
            total_index += 1

with open(os.path.join(dirname, "merged.json"), "w") as outfile:
    json.dump(all_words, outfile, indent=" ")

# print(alternate_spellings)
# sys.exit()
