//

import Cocoa

class ToolbarDelegate: NSObject, NSToolbarDelegate {
  let searchField: NSSearchField

  init(searchField: NSSearchField) {
    self.searchField = searchField
  }

  func toolbar(
    _: NSToolbar,
    itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
    willBeInsertedIntoToolbar _: Bool) -> NSToolbarItem?
  {
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

  func toolbarAllowedItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
    [.searchField]
  }

  func toolbarDefaultItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
    [.searchField]
  }
}
