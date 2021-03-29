import Cocoa

extension NSScrollView {
  static func makeCustom(enclosedTableView: NSTableView) -> NSScrollView {
    let scrollView = NSScrollView()
    scrollView.hasVerticalScroller = true
    scrollView.hasHorizontalRuler = false
    let clipView = NSClipView()
    clipView.documentView = enclosedTableView
    scrollView.contentView = clipView
    return scrollView
  }
}
