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

    var managedWindowControllers = [WindowController]()

    func applicationDidFinishLaunching(_ notification: Notification) {
        try? SpellingInstaller().install()
        makeNewWindow(tabbed: false)
        NSApp.servicesProvider = self
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag { makeNewWindow(tabbed: false) }
        return true
    }

    func makeNewWindow(tabbed: Bool) {
        let windowController = WindowController(tabbed: tabbed)
        windowController.window?.delegate = self
        managedWindowControllers.append(windowController)
    }

    @objc func defineInMilonchikServiceHandler(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        if NSApp.windows.isEmpty {
            makeNewWindow(tabbed: false)
        }
        if
            let index = managedWindowControllers.firstIndex(where: { $0.window?.canBecomeMain ?? false }),
            let text = pboard.string(forType: .string) {
            managedWindowControllers[index].performSearch(text)
        }
    }

    @IBAction func newWindowForTab(_ sender: Any?) {
        makeNewWindow(tabbed: true)
    }

    @IBAction func newWindow(_ sender: Any?) {
        makeNewWindow(tabbed: false)
    }
}

// MARK: - NSWindowDelegate
extension AppDelegate: NSWindowDelegate {
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
