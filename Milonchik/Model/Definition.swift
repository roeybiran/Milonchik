//

import Foundation
import SQLite

// MARK: - Definition

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
}

extension Definition {
  init(_ row: Row) {
    id = Int(row[Columns.id])
    translatedWord = row[Columns.translatedWord]
    translatedWordSanitized = row[Columns.translatedWordSanitized]
    translations = row[Columns.translations].trimmedAndSplittedByTab()
    partOfSpeech = row[Columns.partOfSpeech]
    synonyms = row[Columns.synonyms].trimmedAndSplittedByTab()
    let inflectionKinds = row[Columns.inflectionKind].trimmedAndSplittedByTab()
    let inflectionValues = row[Columns.inflectionValue].trimmedAndSplittedByTab()
    inflections = zip(inflectionKinds, inflectionValues).map { Inflection(kind: $0, value: $1) }
    samples = row[Columns.samples].trimmedAndSplittedByTab()
    translatedLanguage = TranslatedLanguage(rawValue: row[Columns.translatedLanguage])!
  }
}

// MARK: TableViewDisplayable

extension Definition: TableViewDisplayable {
  var label: String { translatedWord }
}

// MARK: Hashable

extension Definition: Hashable {
  static func == (lhs: Definition, rhs: Definition) -> Bool {
    lhs.id == rhs.id
  }
}

// MARK: - Inflection

struct Inflection {
  let kind: Substring
  let value: Substring
}

// MARK: Hashable

extension Inflection: Hashable {}

// MARK: - TranslatedLanguage

enum TranslatedLanguage: String {
  case heb, eng
}
