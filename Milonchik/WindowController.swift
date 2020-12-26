//
//  MLNWindowController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    private let searchField = NSSearchField()
    private let progressIndicator = NSProgressIndicator.custom
    private var viewController: ViewController!
    private let selectors: Set<Selector> = [
        #selector(moveForward),
        #selector(moveBackward),
        #selector(moveDown),
        #selector(moveUp),
        #selector(moveToBeginningOfParagraph),
        #selector(moveToEndOfParagraph)
    ]

    init(tabbed: Bool) {
        let _viewController = ViewController()
        let window = NSWindow.makeCustom(contentViewController: _viewController)
        window.setFrameAutosaveName("MainWindow")

        super.init(window: window)
        self.viewController = _viewController

        searchField.delegate = self
        searchField.target = self
        searchField.action = #selector(performSearch)
        searchField.recentsAutosaveName = "SearchFieldRecents"

        let toolbar = NSToolbar(identifier: "Toolbar")
        toolbar.displayMode = .iconOnly
        toolbar.delegate = self
        window.toolbar = toolbar
        windowFrameAutosaveName = "MainWindow"

        if let existingWindow = NSApp.mainWindow {
            if tabbed {
                existingWindow.addTabbedWindow(window, ordered: .above)
            } else {
                NSWindow.allowsAutomaticWindowTabbing = false
                let cascadingPoint = existingWindow.cascadeTopLeft(from: .zero)
                window.cascadeTopLeft(from: cascadingPoint)
            }
        }
        window.makeKeyAndOrderFront(nil)
        window.makeFirstResponder(searchField)

        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(handleViewControllerStateChange),
                         name: .viewControllerStateDidChange, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleViewControllerStateChange() {
        if viewController.state.operationInProgress {
            progressIndicator.startAnimation(nil)
        } else {
            progressIndicator.stopAnimation(nil)
        }
        if let title = viewController.state.proposedWindowTitle {
            window?.title = title
        }

        if let subtitle = viewController.state.proposedWindowSubtitle {
            if #available(OSX 11.0, *) {
                window?.subtitle = subtitle
            } else {
            // Fallback on earlier versions
            }
        }
    }

    @IBAction func focusSearchField(_ sender: Any?) {
        window?.makeFirstResponder(searchField)
        searchField.selectText(nil)
    }

    /// performSearch
    /// - Parameter text: supply a value to invoke search programatically, e.g. `serviceProvider`.
    @objc func performSearch(_ text: Any?) {
        if let text = text as? String {
            searchField.stringValue = text
        }
        viewController.performSearch(with: searchField.stringValue)
    }

}

extension WindowController: NSSearchFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if selectors.contains(commandSelector), let event = NSApp.currentEvent {
            viewController.listViewController.tableView.keyDown(with: event)
            return true
        }
        return false
    }
}

extension WindowController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case .progressIndicator:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.menuFormRepresentation = nil
            item.view = progressIndicator
            return item
        case .searchField:
            if #available(macOS 11, *) {
                let item = NSSearchToolbarItem(itemIdentifier: itemIdentifier)
                item.searchField = searchField
                item.resignsFirstResponderWithCancel = true
                return item
            }
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.view = searchField
            return item
        default:
            return nil
        }
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.progressIndicator, .searchField]
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.progressIndicator, .searchField]
    }
}

extension NSToolbarItem.Identifier {
    static let searchField = NSToolbarItem.Identifier("SearchFieldToolbarItem")
    static let progressIndicator = NSToolbarItem.Identifier("ProgressIndicator")
}
