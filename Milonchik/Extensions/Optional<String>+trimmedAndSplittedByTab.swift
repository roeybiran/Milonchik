//

import Foundation

extension Optional where Wrapped == String {
  func trimmedAndSplittedByTab() -> [Substring] {
    self?.trimmedAndSplittedByTab() ?? []
  }
}
