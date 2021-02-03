import Foundation

typealias Query = String
typealias Markup = String

protocol DatabaseFetching {
    func cancelFetch()
    func fetch(query: String, completionHandler: @escaping (DatabaseResult) -> Void)
}

class ModelController {
    enum ExternalState {
        case noQuery(markup: Markup, windowData: WindowTitle)
        case noResults(markup: Markup, windowData: WindowTitle)
        case results(items: [TableViewDisplayable], windowData: WindowTitle)
        case showDetail(markup: Markup)
        case error(Error)
    }

    enum InternalState {
        case launched
        case queryChanged(to: String)
        case definitionSelectionChanged(to: TableViewDisplayable)
    }

    var onStateChange: ((ExternalState) -> Void)?
    var externalState: ExternalState? {
        didSet {
            if let state = externalState {
                onStateChange?(state)
            }
        }
    }

    let databaseFetcher: DatabaseFetching
    let htmlFormatter: HTMLFormatter

    init(dbFetcher: DatabaseFetching = DatabaseFetcher()) {
        databaseFetcher = dbFetcher
        guard
            let htmlFile = Bundle.main.path(forResource: "DefinitionDetail", ofType: "html"),
            let template = try? String(contentsOfFile: htmlFile, encoding: .utf8)
        else {
            preconditionFailure("Definition detail HTML template file is missing or corrupt")
        }
        htmlFormatter = HTMLFormatter(baseTemplate: template)
    }

    func mutate(into newState: InternalState) {
        switch newState {
        case .launched:
            externalState = .noQuery(markup: htmlFormatter.markup(for: .noQuery), windowData: WindowTitle.default)
        case let .queryChanged(newQuery):
            let query = newQuery.trimmingCharacters(in: .whitespacesAndNewlines)
            databaseFetcher.cancelFetch()
            if query.isEmpty {
                externalState = .noQuery(markup: htmlFormatter.markup(for: .noQuery), windowData: WindowTitle.default)
            } else {
                fetch(query)
            }
        case let .definitionSelectionChanged(item):
            guard let definition = item as? Definition else { return }
            externalState = .showDetail(markup: htmlFormatter.markup(for: .definition(definition)))
        }
    }

    private func fetch(_ query: String) {
        databaseFetcher.fetch(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                let partialMatches = response.partialMatches
                let exactMatches = response.exactMatches
                let allMatches: [TableViewDisplayable] = exactMatches + [GroupRow()] + partialMatches
                let items = partialMatches.isEmpty ? exactMatches : allMatches
                self.externalState = .results(items: items, windowData: WindowTitle(query: response.query, resultCount: exactMatches.count))
            case let .failure(DatabaseError.noDefinitions(query)):
                let markup = self.htmlFormatter.markup(for: .noResults(for: query))
                self.externalState = .noResults(markup: markup, windowData: WindowTitle(query: query, resultCount: 0))
            case .failure(DatabaseError.userCancelled):
                return
            case let .failure(error):
                self.externalState = .error(error)
            }
        }
    }
}
