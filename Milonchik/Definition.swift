//
//  Definition.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation
import SQLite

protocol TableViewDisplayable {
    var label: String { get }
}

struct Definition {
    let id: Int
    let translatedWord: String
    let translatedWordSanitized: String
    let translations: [Substring]
    let partOfSpeech: String?
    let synonyms: [Substring]
    let samples: [Substring]
    let inflections: [Inflection]
    let translatedLanguage: TranslatedLanguage

    init(_ row: Row) {
        self.id = Int(row[Columns.id])
        self.translatedWord = row[Columns.translatedWord]
        self.translatedWordSanitized = row[Columns.translatedWordSanitized]
        self.translations = row[Columns.translations].trimmedAndSplittedByTab()
        self.partOfSpeech = row[Columns.partOfSpeech]
        self.synonyms = row[Columns.synonyms].trimmedAndSplittedByTab()
        let inflectionKinds = row[Columns.inflectionKind].trimmedAndSplittedByTab()
        let inflectionValues = row[Columns.inflectionValue].trimmedAndSplittedByTab()
        self.inflections = zip(inflectionKinds, inflectionValues).map { Inflection(kind: $0, value: $1) }
        self.samples = row[Columns.samples].trimmedAndSplittedByTab()
        self.translatedLanguage = TranslatedLanguage(rawValue: row[Columns.translatedLanguage])!
    }
}

extension Definition: TableViewDisplayable {
    var label: String { translatedWord }
}

extension Definition: Hashable {
    static func == (lhs: Definition, rhs: Definition) -> Bool {
        lhs.id == rhs.id
    }
}

extension Optional where Wrapped == String {
    func trimmedAndSplittedByTab() -> [Substring] {
        self?.trimmedAndSplittedByTab() ?? []
    }
}

extension String {
    func trimmedAndSplittedByTab() -> [Substring] {
        self.split(separator: "\t")
    }
}
