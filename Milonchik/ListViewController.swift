import Cocoa

/// a  view controller that manages a list of definitions and its associated `NSSplitViewItem`.
final class ListViewController: NSViewController {

    let tableView = NSTableView.custom
    private var items = [TableViewDisplayable]()
    var onSelectionChange: ((TableViewDisplayable) -> Void)?

    /// Initializes a new `ListViewController`.
    /// - Parameter onSelect: a handler to be called when a new definition has been selected.
    init() {
        // onSelection = onSelect
        super.init(nibName: nil, bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSScrollView.makeCustom(enclosedTableView: tableView)
    }

    func updateListItems(with items: [TableViewDisplayable]) {
        self.items.removeAll(keepingCapacity: true)
        self.items = items
        tableView.reloadData()
        if items.count > 0 {
            guard let firstValidRow = items.firstIndex(where: { !($0 is GroupRow) }) else { return }
            tableView.selectRowIndexes([firstValidRow], byExtendingSelection: false)
        }
    }

}

// MARK: - NSTableViewDataSource
extension ListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
}

// MARK: - NSTableViewDelegate
extension ListViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier: NSUserInterfaceItemIdentifier = items[row] is GroupRow ? .groupRowCell : .regularCell
        if let cellView = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView {
            cellView.textField?.stringValue = items[row].label
            return cellView
        }
        return NSTableCellView.makeCustom(label: items[row].label, identifier: identifier)
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        onSelectionChange?(items[tableView.selectedRow])
    }

    // FIXME: FB8946005
    // func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
    //     if items[row] is GroupRow { return true }
    //     return false
    // }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if items[row] is GroupRow { return false }
        return true
    }
}
