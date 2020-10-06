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

    private func makeNewWindow(tabbed: Bool) {
        let storyboard = NSStoryboard.main!
        let newWindowController = storyboard.instantiateInitialController() as! WindowController
        newWindowController.tabbingDelegate = self
        let newWindow = newWindowController.window!
        NSWindow.allowsAutomaticWindowTabbing = tabbed
        managedControllers.append(newWindowController)
        if let existingWindow = NSApp.mainWindow, tabbed {
            existingWindow.addTabbedWindow(newWindow, ordered: .above)
        }
        newWindow.makeKeyAndOrderFront(self)
    }

    @IBAction func newWindowForTab(_ sender: Any?) {
        makeNewWindow(tabbed: true)
    }

    @IBAction func newWindow(_ sender: Any?) {
        makeNewWindow(tabbed: false)
    }

    func tabDidAppear(_ tab: NSWindow) {
        // managedControllers.append(window.windowController!)
    }

    func tabDidClose(_ tab: NSWindow) {
        managedControllers.removeAll(where: { $0 === tab.windowController! })
    }
}
