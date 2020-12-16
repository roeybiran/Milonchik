//
//  MLNWebView.swift
//  Milonchik
//
//  Created by Roey Biran on 01/10/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
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
