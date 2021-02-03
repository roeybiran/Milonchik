//

import Cocoa

class ToolbarDelegate: NSObject, NSToolbarDelegate {
    let searchField: NSSearchField

    init(searchField: NSSearchField) {
        self.searchField = searchField
    }

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
