import Foundation

extension String {
    func trimmedAndSplittedByTab() -> [Substring] {
        split(separator: "\t")
    }
}
