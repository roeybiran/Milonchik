import Foundation

extension String {
    func trimmedAndSplittedByTab() -> [Substring] {
        self.split(separator: "\t")
    }
}
