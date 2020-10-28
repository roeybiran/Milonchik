import Cocoa

/// a  view controller that manages a list of definitions and its associated `NSSplitViewItem`.
final class ListViewController: NSViewController, StateResponding {

    @IBOutlet private var tableView: NSTableView!

    /// the `NSSplitViewItem` managed by this controller.
    var sidebar: SidebarView!

    /// a handler called when a new definition has been selected.
    var userSelectionChangedHandler: ((_ newDefinition: Definition) -> Void)?

    private var items = [Definition?]()

    func update(with state: ViewController.State) {
        switch state {
        case .results(let result):
            items.removeAll()
            items.append(contentsOf: result.exactMatches)
            if !result.partialMatches.isEmpty {
                items.append(contentsOf: [nil] + result.partialMatches)
            }
            sidebar.isCollapsed = false
        case .noQuery, .noResults:
            items.removeAll()
            sidebar.animator().isCollapsed = true
        default:
            return
        }
        tableView.reloadData()
        if items.count > 0 {
            guard let firstValidRow = items.firstIndex(where: { $0 != nil }) else { return }
            tableView.selectRowIndexes([firstValidRow], byExtendingSelection: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsEmptySelection = false

        NotificationCenter
            .default
            .addObserver(self, selector: #selector(searchFieldKeydown), name: .searchFieldKeyDown, object: nil)
    }

}

extension ListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
}

extension ListViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let definition = items[row] else {
            return tableView.makeView(withIdentifier: .suggestionCellView, owner: nil)
        }
        let cellView = tableView.makeView(withIdentifier: .primaryCellView, owner: nil)
        if let cell = cellView as? NSTableCellView {
            cell.textField?.stringValue = definition.inputWord
            return cell
        }
        return nil
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let selectedDefinition = items[tableView.selectedRow] else { return }
        userSelectionChangedHandler?(selectedDefinition)
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if row > items.count - 1 || row < 0 || items[row] == nil {
            return false
        }
        return true
    }
}

/*
    FIXME: find a better solution that this
    perhaps using action messages directly?
    - testing shows NSTableView responds to:
    - scrollToBeginningOfDocument:
    - scrollToEndOfDocument:
    - selectAll:
    - cancelOperation:
 */
extension ListViewController {
    @objc func searchFieldKeydown() {
        guard let event = NSApp.currentEvent else { return }
        tableView.keyDown(with: event)
    }
}
