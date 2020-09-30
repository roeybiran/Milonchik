//
//  AppDelegate.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var managedControllers = [NSWindowController]()
}

// MARK: - tabbing
extension AppDelegate: TabbingDelegate {
    @IBAction func newWindowForTab(_ sender: Any?) {
        let storyboard = NSStoryboard.main!
        let newWindowController = storyboard.instantiateInitialController() as! WindowController
        newWindowController.tabbingDelegate = self
        let newWindow = newWindowController.window!
        managedControllers.append(newWindowController)
        if let existingWindow = NSApp.mainWindow {
            existingWindow.addTabbedWindow(newWindow, ordered: .above)
        }
        newWindow.makeKeyAndOrderFront(self)
    }

    func tabDidAppear(_ tab: NSWindow) {
        // managedControllers.append(window.windowController!)
    }

    func tabDidClose(_ tab: NSWindow) {
        managedControllers.removeAll(where: { $0 === tab.windowController! })
    }
}
