import Foundation

typealias Query = String
typealias Markup = String

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

    let databaseController: DatabaseFetcher
    let htmlFormatter: HTMLFormatter

    init() {
        databaseController = DatabaseFetcher()
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
        case .queryChanged(let newQuery):
            let query = newQuery.trimmingCharacters(in: .whitespacesAndNewlines)
            databaseController.cancelFetch()
            if query.isEmpty {
                externalState = .noQuery(markup: htmlFormatter.markup(for: .noQuery), windowData: WindowTitle.default)
            } else {
                fetch(query)
            }
        case .definitionSelectionChanged(let item):
            guard let definition = item as? Definition else { return }
            externalState = .showDetail(markup: htmlFormatter.markup(for: .definition(definition)))
        }
    }

    private func fetch(_ query: String) {
        databaseController.fetch(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let partialMatches = response.partialMatches
                let exactMatches = response.exactMatches
                let allMatches: [TableViewDisplayable] = exactMatches + [GroupRow()] + partialMatches
                let items = partialMatches.isEmpty ? exactMatches : allMatches
                self.externalState = .results(items: items, windowData: WindowTitle(query: response.query, resultCount: exactMatches.count))
            case .failure(DatabaseError.noDefinitions(let query)):
                let markup = self.htmlFormatter.markup(for: .noResults(for: query))
                self.externalState = .noResults(markup: markup, windowData: WindowTitle(query: query, resultCount: 0))
            case .failure(DatabaseError.userCancelled):
                return
            case .failure(let error):
                self.externalState = .error(error)
            }
        }
    }
}
