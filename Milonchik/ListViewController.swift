import Cocoa

/// a  view controller that manages a list of definitions and its associated `NSSplitViewItem`.
final class ListViewController: NSViewController, StateResponding {

    @IBOutlet private var tableView: NSTableView!

    /// the `NSSplitViewItem` managed by this controller.
    var sidebar: SidebarView!

    /// a handler called when a new definition has been selected.
    var userSelectionChangedHandler: ((_ newDefinition: Definition) -> Void)?

    private var definitions = [Definition]()

    func update(with state: ViewController.State) {
        switch state {
        case .results(let definitions, _):
            self.definitions = definitions
            sidebar.isCollapsed = false
        case .noQuery, .noResults:
            definitions.removeAll()
            sidebar.animator().isCollapsed = true
        default:
            return
        }
        tableView.reloadData()
        if definitions.count > 0 {
            tableView.selectRowIndexes([0, 0], byExtendingSelection: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
        return definitions.count
    }
}

extension ListViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = definitions[row]
        let cellView = tableView.makeView(withIdentifier: .tableCellView, owner: nil)
        if let cell = cellView as? NSTableCellView {
            cell.textField?.stringValue = item.inputWord
            return cell
        }
        return nil
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        userSelectionChangedHandler?(definitions[tableView.selectedRow])
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
