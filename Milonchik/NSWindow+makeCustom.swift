//
//  Window.swift
//  Milonchik
//
//  Created by Roey Biran on 07/12/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

extension NSWindow {
    static func makeCustom(contentViewController: NSViewController) -> NSWindow {
        let window = NSWindow(contentViewController: contentViewController)
        window.setFrameAutosaveName("MainWindow")
        window.styleMask = [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView]
        window.title = Constants.appName
        window.minSize = CGSize(width: 580, height: 300)
        return window
    }
}
