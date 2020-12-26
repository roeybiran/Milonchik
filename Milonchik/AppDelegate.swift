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

    let windowManager = WindowManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        try? SpellingInstaller().install()
        windowManager.makeNewWindow(tabbed: false)
        NSApp.servicesProvider = windowManager
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag { windowManager.makeNewWindow(tabbed: false) }
        return true
    }

    @IBAction func newWindowForTab(_ sender: Any?) {
        windowManager.makeNewWindow(tabbed: true)
    }

    @IBAction func newWindow(_ sender: Any?) {
        windowManager.makeNewWindow(tabbed: false)
    }

}
