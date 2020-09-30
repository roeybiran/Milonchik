//
//  MLNSplitViewController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

protocol StateResponding {
    func update(with state: ViewController.State)
}

protocol ViewControllerDelegate: AnyObject {
    func didChangeState(to state: ViewController.State)
}

import Cocoa

final class ViewController: NSSplitViewController {

    enum State {
        case noQuery
        case queryChanged(to: String)
        case fetchShouldStart(withQuery: String)
        case fetchDidEnd(with: Result<[Definition], MilonchikError>, forQuery: String)
        case definitionSelectionChanged(to: Definition)
        case results(definitions: [Definition], forQuery: String)
        case noResults(forQuery: String)
        case error(Error)
    }

    @IBOutlet private var sidebar: SideBar!

    weak var delegate: ViewControllerDelegate?

    fileprivate(set) var state: State! {
        didSet {
            handleStateChange(newState: state)
        }
    }
    private var wordModelController = ModelController()
    private var listViewController: ListViewController!
    private var detailViewController: DetailViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        listViewController = sidebar.viewController as? ListViewController
        listViewController.userSelectionChangedHandler = { definition in
            self.state = .definitionSelectionChanged(to: definition)
        }
        listViewController.sidebar = sidebar
        detailViewController = splitViewItems.last?.viewController as? DetailViewController
        state = .noQuery

    }

    // MARK: - state
    private func handleStateChange(newState: State) {
        switch newState {
        case .noQuery, .results, .noResults, .definitionSelectionChanged:
            updateViews(with: newState)
        case .queryChanged(let query):
            if query.isEmpty {
                state = .noQuery
            } else {
                state = .fetchShouldStart(withQuery: query)
            }
        case .fetchShouldStart(let query):
            wordModelController.cancel()
            wordModelController.fetch(query: query) { result in
                DispatchQueue.main.async {
                    self.state = .fetchDidEnd(with: result, forQuery: query)
                }
            }
        case let .fetchDidEnd(result, query):
            switch result {
            case .success(let definitions):
                state = .results(definitions: definitions, forQuery: query)
            case .failure(.noDefinitions):
                state = .noResults(forQuery: query)
            case .failure(.SQLError(let error)):
                state = .error(error)
            }
        //FIXME: better error handling
        case .error(let error):
            presentError(error)
        }
        delegate?.didChangeState(to: newState)
    }

    private func updateViews(with newState: State) {
        splitViewItems.forEach({ splitView in
            if let child = splitView.viewController as? StateResponding {
                child.update(with: newState)
            }
        })
    }

    // first responder
    @IBAction private func searchFieldContentsChanged(_ sender: NSTextField) {
        state = .queryChanged(to: sender.stringValue)
    }
}
