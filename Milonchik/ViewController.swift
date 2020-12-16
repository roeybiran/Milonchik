//
//  MLNSplitViewController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//
import Cocoa

final class ViewController: NSSplitViewController {

    private(set) var state: State! {
        didSet {
            handleStateChange(newState: state)
        }
    }
    private func handleStateChange(newState: State) {
        NotificationCenter.default.post(name: .viewControllerStateDidChange, object: nil)
        switch newState {
        case .noQuery:
            updateViews(with: newState)
        case .queryChanged(let query):
            wordModelController.cancelFetch()
            state = query.isEmpty ? .noQuery : .fetchShouldStart(withQuery: query)
        case .fetchShouldStart(let query):
            wordModelController.fetch(query: query) { result in
                DispatchQueue.main.async {
                    self.state = .fetchDidEnd(with: result)
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

    let listViewController = ListViewController()
    private let wordModelController = ModelController()
    private let detailViewController = DetailViewController()

    override func loadView() {
        view = splitView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        splitView.isVertical = true
        splitView.setFrameSize(CGSize(width: 640, height: 400))
        splitView.autosaveName = "SplitView"
        let listSplitViewItem = NSSplitViewItem(sidebarWithViewController: listViewController)
        let detailSplitViewItem = NSSplitViewItem(viewController: detailViewController)
        detailSplitViewItem.minimumThickness = (view.window?.frame.width ?? 600) / 2
        detailSplitViewItem.canCollapse = false

        splitViewItems = [
            listSplitViewItem,
            detailSplitViewItem
        ]

        listViewController.onSelection = { selectedDefinition in
            self.state = .definitionSelectionChanged(to: selectedDefinition)
        }

        state = .noQuery
    }

    func performSearch(with text: String) {
        state = .queryChanged(to: text.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    private func updateViews(with newState: State) {
        splitViewItems.forEach({ splitView in
            if let child = splitView.viewController as? StateResponding {
                child.update(with: newState)
            }
        })
    }
}

protocol StateResponding {
    func update(with state: State)
}
