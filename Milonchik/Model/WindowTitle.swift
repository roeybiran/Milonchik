//

import Foundation

struct WindowTitle {
  let title: String
  let subtitle: String
  init(query: String, resultCount: Int) {
    title = "”\(query)”"
    subtitle = resultCount > 100 ? "More than 100 found" : "\(resultCount) found"
  }

  private init(title: String, subtitle: String) {
    self.title = title
    self.subtitle = subtitle
  }

  static let `default` = WindowTitle(title: Constants.appName, subtitle: "")
}
