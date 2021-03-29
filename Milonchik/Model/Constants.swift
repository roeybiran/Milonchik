import Cocoa
import SQLite

// MARK: - Constants

enum Constants {
  static let appName = "Milonchik"
  static let noQueryPlaceholder = "Look up a word by typing in the search field above."
}

extension NSUserInterfaceItemIdentifier {
  static let regularCell = NSUserInterfaceItemIdentifier("RegularCell")
  static let groupRowCell = NSUserInterfaceItemIdentifier("GroupRowCell")
}

extension NSToolbarItem.Identifier {
  static let searchField = NSToolbarItem.Identifier("SearchFieldToolbarItem")
}

// MARK: - Tables

enum Tables {
  static let definitions = Table("definitions")
}

// MARK: - Columns

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
