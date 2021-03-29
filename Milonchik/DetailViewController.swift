import Cocoa
import WebKit

final class DetailViewController: NSViewController {
  lazy var detailView: DetailView = {
    let detailView = DetailView()
    // FIXME: white flash
    detailView.isHidden = true
    return detailView
  }()

  override func loadView() {
    view = detailView
  }

  func display(_ html: Markup) {
    detailView.loadHTMLString(html, baseURL: nil)
    // white flash
    if detailView.isHidden {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.detailView.animator().isHidden = false
      }
    }
  }
}
