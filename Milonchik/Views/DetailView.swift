//

import Cocoa
import WebKit

class DetailView: WKWebView {

    override func willOpenMenu(_ menu: NSMenu, with event: NSEvent) {
        menu.items.first(where: { $0.identifier?.rawValue == "WKMenuItemIdentifierReload" })?.isHidden = true
    }

    override func mouseDown(with event: NSEvent) {
        window?.makeFirstResponder(self)
        super.mouseDown(with: event)
    }
}
