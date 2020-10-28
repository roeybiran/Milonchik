//
//  ServicesManager.swift
//  Milonchik
//
//  Created by Roey Biran on 09/10/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

class ServicesManager: NSObject {
    @objc func defineServiceHandler(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        //FIXME: extremely coupled. try to use first responder
        NSApp.enumerateWindows { (window, _) in
            guard
                let controller = window.windowController as? WindowController,
                let text = pboard.string(forType: .string) else { return }
            controller.setSearchFieldContents(to: text)
        }
    }
}
