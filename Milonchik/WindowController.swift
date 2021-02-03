import Cocoa

class WindowController: NSWindowController {
    lazy var searchField: SearchField = {
        let _searchField = SearchField()
        _searchField.delegate = self
        _searchField.target = self
        _searchField.action = #selector(performSearch)
        _searchField.recentsAutosaveName = "SearchFieldRecents"
        return _searchField
    }()

    @objc let viewController: ViewController
    var toolbarDelegate: ToolbarDelegate?
    let notificationCenter = NotificationCenter.default
    let selectors = Set([
        #selector(moveForward),
        #selector(moveBackward),
        #selector(moveDown),
        #selector(moveUp),
        #selector(moveToBeginningOfParagraph),
        #selector(moveToEndOfParagraph),
    ])

    var viewControllerObservation: NSKeyValueObservation?

    init(tabbed: Bool = false) {
        viewController = ViewController()
        let window = NSWindow.makeCustom(contentViewController: viewController)
        super.init(window: window)
        viewController.notifyObservers = { [weak self] in
            guard let self = self else { return }
            self.searchField.shouldAnimate = self.viewController.progressShouldAnimate
            self.window?.title = self.viewController.windowData.title
            if #available(OSX 11.0, *) {
                self.window?.subtitle = self.viewController.windowData.subtitle
            }
        }

        let toolbar = NSToolbar(identifier: "Toolbar")
        toolbarDelegate = ToolbarDelegate(searchField: searchField)
        toolbar.displayMode = .iconOnly
        toolbar.delegate = toolbarDelegate
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
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func focusSearchField(_: Any?) {
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
    func control(_: NSControl, textView _: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if selectors.contains(commandSelector) {
            if let event = window?.currentEvent, event.type == .keyDown {
                viewController.listViewController.tableView.keyDown(with: event)
            }
            return true
        }
        return false
    }
}

// extension WindowController: NSToolbarDelegate {
//     func toolbar(_ toolbar: NSToolbar,
//                  itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
//                  willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
//         switch itemIdentifier {
//         case .searchField:
//             if #available(macOS 11, *) {
//                 let item = NSSearchToolbarItem(itemIdentifier: itemIdentifier)
//                 item.searchField = searchField
//                 item.resignsFirstResponderWithCancel = true
//                 return item
//             }
//             let item = NSToolbarItem(itemIdentifier: itemIdentifier)
//             item.view = searchField
//             return item
//         default:
//             return nil
//         }
//     }
//
//     func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//         return [.searchField]
//     }
//
//     func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//         return [.searchField]
//     }
// }
