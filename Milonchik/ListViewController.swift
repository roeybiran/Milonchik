import Cocoa

/// a  view controller that manages a list of definitions and its associated `NSSplitViewItem`.
final class ListViewController: NSViewController, StateResponding {

    private struct GroupRow: TableViewDisplayable {
        var label: String { "Suggestions" }
    }

    let tableView = NSTableView.custom
    private var items = [TableViewDisplayable]()
    /// a handler called when a new definition has been selected.
    var onSelection: ((_ newDefinition: Definition) -> Void)?

    override func loadView() {
        view = NSScrollView.makeCustom(enclosedTableView: tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func update(with state: State) {
        switch state {
        case .results(let result):
            items.removeAll(keepingCapacity: true)
            items = result.exactMatches
            if !result.partialMatches.isEmpty {
                items.append(contentsOf: [GroupRow()] + result.partialMatches)
            }
        case .noQuery, .noResults:
            items.removeAll(keepingCapacity: true)
        default:
            return
        }
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
        if let cellView = tableView.makeView(withIdentifier: .tableCell, owner: nil) as? NSTableCellView {
            cellView.textField?.stringValue = items[row].label
            return cellView
        }
        return NSTableCellView.makeCustom(label: items[row].label)
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let selectedDefinition = items[tableView.selectedRow] as? Definition else { return }
        onSelection?(selectedDefinition)
    }

    func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        if items[row] is GroupRow { return true }
        return false
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if items[row] is GroupRow { return false }
        return true
    }

}

extension NSUserInterfaceItemIdentifier {
    static let tableCell = NSUserInterfaceItemIdentifier("Cell")
}
