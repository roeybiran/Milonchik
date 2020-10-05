//
//  DetailView.swift
//  Milonchik
//
//  Created by Roey Biran on 05/10/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

class DetailView: NSView {

    override func updateLayer() {
        layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
    }
}
