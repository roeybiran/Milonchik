//
//  MLNSplitViewController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//
import Cocoa

protocol StateResponding {
    func update(with state: ViewController.State)
}

protocol ViewControllerDelegate: AnyObject {
    func didChangeState(to state: ViewController.State)
}

final class ViewController: NSSplitViewController {

    @IBOutlet private var sidebar: SidebarView!

    fileprivate(set) var state: State! {
        didSet {
            handleStateChange(newState: state)
        }
    }

    weak var delegate: ViewControllerDelegate?

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
        case .noQuery:
            updateViews(with: newState)
        case .queryChanged(let query):
            state = query.isEmpty ? .noQuery : .fetchShouldStart(withQuery: query)
        case .fetchShouldStart(let query):
            wordModelController.cancelFetch()
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
        case .results, .noResults, .definitionSelectionChanged:
            updateViews(with: newState)
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

    @IBAction func performSearch(_ sender: NSTextField) {
        state = .queryChanged(to: sender.stringValue.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

extension ViewController {
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
}
