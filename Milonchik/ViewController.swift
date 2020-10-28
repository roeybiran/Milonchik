//
//  MLNSplitViewController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//
import Cocoa

final class ViewController: NSSplitViewController {

    enum State {
        case noQuery
        case queryChanged(to: String)
        case fetchShouldStart(withQuery: String)
        case fetchDidEnd(with: Result<DBFetchResult, MilonchikError>)
        case definitionSelectionChanged(to: Definition)
        case results(DBFetchResult)
        case noResults(forQuery: String)
    }

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

    private func handleStateChange(newState: State) {
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
        case let .fetchDidEnd(result):
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

protocol StateResponding {
    func update(with state: ViewController.State)
}

protocol ViewControllerDelegate: AnyObject {
    func didChangeState(to state: ViewController.State)
}
