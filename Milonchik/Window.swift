//
//  Window.swift
//  Milonchik
//
//  Created by Roey Biran on 18/10/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

class Window: NSWindow {
    override func awakeFromNib() {
        setFrameAutosaveName(.mainWindow)
        guard #available(OSX 10.14, *) else { return }
        toolbar?.centeredItemIdentifier = .searchField
    }
}
