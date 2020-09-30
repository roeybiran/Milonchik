//
//  MLNSplitViewController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

final class ViewController: NSSplitViewController {

    private enum State {
        case noQuery
        case queryChanged(query: String)
        case fetchEnded(query: String, definitions: [Definition])
        case definitionSelectionChanged(_: Definition)
        case error(_: Error)
    }

    @IBOutlet var sidebar: MCSideBar!

    var progressHandler: ((_ taskInProgress: Bool) -> Void)?

    private var state: State! {
        didSet {
            handleStateChange(newState: state)
        }
    }
    private var wordModelController = WordModelController()
    private var listViewController: ListViewController!
    private var detailViewController: DetailViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        state = .noQuery

        listViewController = splitViewItems.first?.viewController as? ListViewController
        detailViewController = splitViewItems.last?.viewController as? DetailViewController
        listViewController.userSelectionChangedHandler = { definition in
            self.state = .definitionSelectionChanged(definition)
        }
    }

    // MARK: - state
    private func handleStateChange(newState: State) {
        switch newState {
        case .noQuery:
            listViewController.definitions = []
            sidebar.update(for: 0)
            displayDetail(of: nil, for: nil)
        case .queryChanged(let query):
            if query.isEmpty { state = .noQuery; return }
            progressHandler?(true)
            wordModelController.fetch(query: query) { (definitions, error) in
                DispatchQueue.main.async {
                    self.progressHandler?(false)
                    self.state = error == nil ?
                        .fetchEnded(query: query, definitions: definitions) : .error(error!)
                }
            }
        case let .fetchEnded(query, definitions):
            listViewController.definitions = definitions
            sidebar.update(for: definitions.count)
            if definitions.isEmpty { displayDetail(of: nil, for: query) }
        case .definitionSelectionChanged(let definition):
            displayDetail(of: definition, for: nil)
        case .error:
            fatalError()
        }
    }

    private func displayDetail(of definition: Definition?, for query: String?) {
        do {
            try detailViewController.display(definition: definition, query: query)
        } catch {
            state = .error(error)
        }
    }

    // first responder
    @IBAction private func searchFieldContentsChanged(_ sender: NSTextField) {
        state = .queryChanged(query: sender.stringValue)
    }
}
