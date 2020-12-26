//
//  Constants.swift
//  Milonchik
//
//  Created by Roey Biran on 21/08/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa
import SQLite

enum Constants {
    static let appName = "Milonchik"
}

extension NSNotification.Name {
    static let viewControllerStateDidChange = NSNotification.Name("ViewControllerStateDidChange")
}

enum Tables {
    static let definitions = Table("definitions")
}

enum Columns {
    static let id = Expression<Int64>("id")
    static let translatedLanguage = Expression<String>("translated_lang")
    static let translatedWord = Expression<String>("translated_word")
    static let translatedWordSanitized = Expression<String>("translated_word_sanitized")
    static let partOfSpeech = Expression<String?>("part_of_speech")
    static let synonyms = Expression<String?>("synonyms")
    static let translations = Expression<String>("translations")
    static let samples = Expression<String?>("samples")
    static let inflectionKind = Expression<String?>("inflection_kind")
    static let inflectionValue = Expression<String?>("inflection_value")
    static let alternateSpellings = Expression<String?>("alternate_spellings")
}
