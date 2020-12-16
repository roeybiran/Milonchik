//
//  NSScrollView+makeCustom.swift
//  Milonchik
//
//  Created by Roey Biran on 11/12/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

extension NSScrollView {
    static func makeCustom(enclosedTableView: NSTableView) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.automaticallyAdjustsContentInsets = true
        // scrollView.contentInsets = NSEdgeInsets(top: 32, left: 0, bottom: 8 , right: 0)
        let clipView = NSClipView()
        clipView.documentView = enclosedTableView
        scrollView.contentView = clipView
        return scrollView
    }
}
