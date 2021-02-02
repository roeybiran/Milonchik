import Cocoa

extension NSTableView {
    static var custom: NSTableView {
        let tableView = NSTableView()
        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        tableView.headerView = nil
        tableView.allowsEmptySelection = false
        tableView.allowsColumnReordering = false
        tableView.allowsColumnResizing = true
        tableView.floatsGroupRows = false

        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Column1"))
        column1.width = tableView.frame.size.width
        column1.resizingMask = .autoresizingMask
        tableView.addTableColumn(column1)
        return tableView
    }
}
