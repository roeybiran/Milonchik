import Foundation

extension Set where Element == Definition {
  func sortedByRelevance(to query: String) -> [Definition] {
    sorted {
      switch ($0.translatedWordSanitized.starts(with: query), $1.translatedWordSanitized.starts(with: query)) {
      case (true, false):
        return true
      case (false, true):
        return false
      default:
        if $0.translatedWordSanitized == $1.translatedWordSanitized {
          return $0.translatedWordSanitized < $1.translatedWordSanitized
        }
        return $0.id < $1.id
      }
    }
  }
}
