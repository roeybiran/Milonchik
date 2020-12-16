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
        NSApp.servicesProvider = self
        // try? HebrewSpellingInstaller().install()
        makeNewWindow(tabbed: false)
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

    private func installHebrewSpellchecker() throws {
        let fm = FileManager.default
        guard let library = fm.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            throw MilonchikError.HebrewSpellingInstallerError.spellingDirectoryAccessFailure
        }
        let spellingDirectory = library.appendingPathComponent("Spelling", isDirectory: true)
        let files: [(name: String, ext: String)] = [("he_IL", "aff"), ("he_IL", "dic")]
        try files.forEach({ file in
            let dst = spellingDirectory.appendingPathComponent(file.name).appendingPathExtension(file.ext)
            if fm.fileExists(atPath: dst.path) { return }
            let src = Bundle.main.url(forResource: file.name, withExtension: file.ext)!
            do {
                try fm.createDirectory(at: spellingDirectory, withIntermediateDirectories: true)
                try fm.copyItem(at: src, to: dst)
            } catch let error as CocoaError where error.code == CocoaError.fileWriteFileExists {
                return
            } catch {
                throw error
            }
        })
    }

    @objc func defineServiceHandler(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        if NSApp.windows.isEmpty {
            makeNewWindow(tabbed: false)
        }
        if
            let index = managedWindowControllers.firstIndex(where: { $0.window?.isKeyWindow ?? false }),
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
