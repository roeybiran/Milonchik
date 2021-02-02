import Cocoa

final class ViewController: NSSplitViewController {

    let modelController: ModelController
    let listViewController: ListViewController
    let detailViewController: DetailViewController

    var progressShouldAnimate = false
    var windowData: WindowTitle = .default
    var notifyObservers: (() -> Void)?

    init() {
        listViewController = ListViewController()
        detailViewController = DetailViewController()
        modelController = ModelController()
        super.init(nibName: nil, bundle: nil)

        let listSplitViewItem = NSSplitViewItem(sidebarWithViewController: listViewController)
        let detailSplitViewItem = NSSplitViewItem(viewController: detailViewController)
        detailSplitViewItem.minimumThickness = (view.window?.frame.width ?? 600) / 2
        detailSplitViewItem.canCollapse = false
        splitViewItems = [
            listSplitViewItem,
            detailSplitViewItem
        ]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        listViewController.onSelectionChange = { [weak self] in
            self?.modelController.mutate(into: .definitionSelectionChanged(to: $0))
        }

        modelController.onStateChange = { [weak self] newState in
            DispatchQueue.main.async {
                self?.progressShouldAnimate = false
                switch newState {
                case .results(let results, let windowData):
                    self?.windowData = windowData
                    self?.listViewController.updateListItems(with: results)
                case .showDetail(let markup):
                    self?.detailViewController.display(markup)
                case .noQuery(let markup, let windowData), .noResults(let markup, let windowData):
                    self?.windowData = windowData
                    self?.listViewController.updateListItems(with: [])
                    self?.detailViewController.display(markup)
                case .error:
                    break
                }
                self?.notifyObservers?()
            }

        }

        modelController.mutate(into: .launched)
    }

    override func loadView() {
        // programmatic nssplitview:
        // https://github.com/aleffert/dials/blob/b9a5db48e980bb2ed8f3c539e911ec07ea6fb995/Desktop/Source/SidebarSplitViewController.swift
        // https://github.com/Automattic/simplenote-macos/blob/e3ad136028b20ce1038b454555cf673ae78acc83/Simplenote/SplitViewController.swift
        view = splitView
        splitView.autosaveName = "SplitView"
        splitView.isVertical = true
    }

    func performSearch(with text: String) {
        progressShouldAnimate = true
        notifyObservers?()
        modelController.mutate(into: .queryChanged(to: text))
    }
}
