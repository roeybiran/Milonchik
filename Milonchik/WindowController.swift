//
//  MLNWindowController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    lazy var searchField: CustomSearchField = {
        let _searchField = CustomSearchField()
        _searchField.delegate = self
        _searchField.target = self
        _searchField.action = #selector(performSearch)
        _searchField.recentsAutosaveName = "SearchFieldRecents"
        return _searchField
    }()

    let viewController = ViewController()

    private let selectors: Set<Selector> = [
        #selector(moveForward),
        #selector(moveBackward),
        #selector(moveDown),
        #selector(moveUp),
        #selector(moveToBeginningOfParagraph),
        #selector(moveToEndOfParagraph)
    ]

    init(tabbed: Bool = false) {

        let window = NSWindow.makeCustom(contentViewController: viewController)
        super.init(window: window)

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
        searchField.isAnimatingProgress = viewController.state.operationInProgress

        if let title = viewController.state.proposedWindowTitle {
            window?.title = title
        }

        if #available(OSX 11.0, *), let subtitle = viewController.state.proposedWindowSubtitle {
            window?.subtitle = subtitle
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
        return [.searchField]
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.searchField]
    }
}

extension NSToolbarItem.Identifier {
    static let searchField = NSToolbarItem.Identifier("SearchFieldToolbarItem")
}
