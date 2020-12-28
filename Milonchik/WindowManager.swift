//
//  WindowManager.swift
//  Milonchik
//
//  Created by Roey Biran on 26/12/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import AppKit

class WindowManager: NSObject {

    var managedWindowControllers = [WindowController]()

    func makeNewWindow(tabbed: Bool) {
        let windowController = WindowController(tabbed: tabbed)
        windowController.window?.delegate = self
        managedWindowControllers.append(windowController)
    }

    @objc func defineInMilonchikServiceHandler(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        if NSApp.windows.isEmpty { makeNewWindow(tabbed: false) }

        guard
            let firstWindow = NSApp.orderedWindows.first,
            let controller = managedWindowControllers.first(where: { $0.window === firstWindow }),
            let text = pboard.string(forType: .string)
        else {
            return
        }
        controller.performSearch(text)
    }
}

// MARK: - NSWindowDelegate
extension WindowManager: NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        managedWindowControllers.removeAll(where: { $0.window === sender })
        return true
    }

    func windowDidBecomeKey(_ notification: Notification) {
        if let index = managedWindowControllers.firstIndex(where: { $0.window?.isKeyWindow ?? false }) {
            managedWindowControllers[index].focusSearchField(nil)
        }
    }

}
