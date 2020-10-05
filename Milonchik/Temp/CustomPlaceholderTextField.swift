//
//  CustomPlaceholderTextField.swift
//  Milonchik
//
//  Created by Roey Biran on 05/10/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

class CustomPlaceholderTextField: NSTextField {

    override var intrinsicContentSize: NSSize {
        return NSSize(width: superview!.frame.width * 0.8, height: super.intrinsicContentSize.height)
    }
    override func resize(withOldSuperviewSize oldSize: NSSize) {
        invalidateIntrinsicContentSize()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

}
