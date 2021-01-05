//
//  MLNSplitViewController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//
import Cocoa

final class ViewController: NSSplitViewController {

    lazy var listViewController = ListViewController(onSelect: { [weak self] in
        self?.state = .definitionSelectionChanged(to: $0)
    })

    private let modelController = ModelController()
    private let detailViewController = DetailViewController()

    private(set) var state = State.noQuery {
        didSet {
            handleStateChange(newState: state)
        }
    }

    // https://github.com/aleffert/dials/blob/b9a5db48e980bb2ed8f3c539e911ec07ea6fb995/Desktop/Source/SidebarSplitViewController.swift
    // https://github.com/Automattic/simplenote-macos/blob/e3ad136028b20ce1038b454555cf673ae78acc83/Simplenote/SplitViewController.swift
    override func loadView() {
        view = splitView
        splitView.autosaveName = "SplitView"
        splitView.isVertical = true
        let listSplitViewItem = NSSplitViewItem(sidebarWithViewController: listViewController)
        let detailSplitViewItem = NSSplitViewItem(viewController: detailViewController)
        detailSplitViewItem.minimumThickness = (view.window?.frame.width ?? 600) / 2
        detailSplitViewItem.canCollapse = false
        splitViewItems = [
            listSplitViewItem,
            detailSplitViewItem
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        state = .noQuery
    }

    private func handleStateChange(newState: State) {
        NotificationCenter.default.post(name: .viewControllerStateDidChange, object: nil)
        switch newState {
        case .noQuery:
            updateViews(with: newState)
        case .queryChanged(let query):
            modelController.cancelFetch()
            state = query.isEmpty ? .noQuery : .fetchShouldStart(withQuery: query)
        case .fetchShouldStart(let query):
            modelController.fetch(query: query) { [weak self] result in
                DispatchQueue.main.async {
                    self?.state = .fetchDidEnd(with: result)
                }
            }
        case .fetchDidEnd(let result):
            switch result {
            case .success(let result):
                state = .results(result)
            case .failure(.noDefinitions(let query)):
                state = .noResults(forQuery: query)
            case .failure(.userCancelled):
                break
            case .failure(.SQLError(let error)):
                //FIXME: better error handling
                presentError(error)
            }
        case .results, .noResults, .definitionSelectionChanged:
            updateViews(with: newState)
        }
    }

    func performSearch(with text: String) {
        state = .queryChanged(to: text.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    private func updateViews(with newState: State) {
        splitViewItems.forEach({
            if let child = $0.viewController as? StateResponding {
                child.update(with: newState)
            }
        })
    }
}

protocol StateResponding {
    func update(with state: State)
}
