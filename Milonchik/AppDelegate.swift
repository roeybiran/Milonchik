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
    //FIXME: is a strong reference needed?
    let serviceManager = ServicesManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.servicesProvider = serviceManager
        try! HebrewSpellingInstaller().install()

        // print(NSSpellChecker.shared.availableLanguages)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag { makeNewWindow(tabbed: false) }
        return true
    }
}

// MARK: - window management
extension AppDelegate {

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
        newWindowController.showWindow(self)
    }

    @IBAction func newWindowForTab(_ sender: Any?) {
        makeNewWindow(tabbed: true)
    }

    @IBAction func newWindow(_ sender: Any?) {
        makeNewWindow(tabbed: false)
    }
}

extension AppDelegate: TabbingDelegate {
    func tabDidAppear(_ tab: NSWindow) {}

    func tabDidClose(_ tab: NSWindow) {
        managedControllers.removeAll(where: { $0 === tab.windowController! })
    }
}
