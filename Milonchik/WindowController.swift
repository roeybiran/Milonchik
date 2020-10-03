//
//  MLNWindowController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

/// A protocol that allows cosnumers to be notified of tab opening & closing events.
protocol TabbingDelegate: AnyObject {
    func tabDidAppear(_ tab: NSWindow)
    func tabDidClose(_ tab: NSWindow)
}

class WindowController: NSWindowController {

    @IBOutlet private var searchField: NSSearchField!
    @IBOutlet private var progressIndicator: NSProgressIndicator!

    weak var tabbingDelegate: TabbingDelegate?

    override func windowDidLoad() {
        super.windowDidLoad()
        shouldCascadeWindows = true

        window?.delegate = self
        searchField.delegate = self

        (contentViewController as! ViewController).delegate = self

        // FIXME: bug - not respected when set in IB
        window?.setFrameAutosaveName(.mainWindow)
    }

    @IBAction func focusSearchField(_ sender: Any?) {
        searchField.window?.makeFirstResponder(searchField)
        searchField.selectText(nil)
    }

}

extension WindowController: NSWindowDelegate {
    func windowDidBecomeKey(_ notification: Notification) {
        focusSearchField(nil)
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        tabbingDelegate?.tabDidClose(sender)
        return true
    }
}

extension WindowController: ViewControllerDelegate {
    func didChangeState(to state: ViewController.State) {
        switch state {
        case .fetchShouldStart:
            progressIndicator.startAnimation(nil)
        case .fetchDidEnd:
            progressIndicator.stopAnimation(nil)
        case let .results(definitions, query):
            let count = definitions.count
            window?.title = "“\(query)” (\(count) \(count > 1 ? "results" : "result"))"
        case .noResults(let query):
            window?.title = "”\(query)” (0 results)"
        case .noQuery:
            window?.title = .appName
        default:
            break

        }
    }
}

extension WindowController: NSSearchFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        print(commandSelector)
        let selectors = [#selector(moveDown(_:)), #selector(moveUp(_:))]
        if selectors.contains(commandSelector) {
            NotificationCenter.default.post(name: .searchFieldKeyDown, object: nil)
            return true
        }
        return false
    }
}
