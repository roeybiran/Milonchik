//
//  State.swift
//  Milonchik
//
//  Created by Roey Biran on 20/11/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

enum State {
    case noQuery
    case queryChanged(to: String)
    case fetchShouldStart(withQuery: String)
    case fetchDidEnd(with: Result<DatabaseResponse, MilonchikError>)
    case definitionSelectionChanged(to: Definition)
    case results(DatabaseResponse)
    case noResults(forQuery: String)

    var definitions: Set<Definition> {
        switch self {
        case .results(let dbFetchResult):
            return dbFetchResult.allMatches
        case .noQuery, .queryChanged, .fetchShouldStart, .fetchDidEnd, .definitionSelectionChanged, .noResults:
            return []
        }
    }

    var operationInProgress: Bool {
        switch self {
        case .fetchShouldStart:
            return true
        case .queryChanged(let query):
            return !query.isEmpty
        case .noQuery, .fetchDidEnd, .definitionSelectionChanged, .results, .noResults:
            return false
        }
    }

    var proposedWindowTitle: String? {
        switch self {
        case .results(let fetchResult):
            let query = fetchResult.query
            return "“\(query)”"
        case .noResults(let query):
            return "”\(query)”"
        case .noQuery:
            return Constants.appName
        case .queryChanged, .fetchShouldStart, .definitionSelectionChanged, .fetchDidEnd:
            return nil
        }
    }

    var proposedWindowSubtitle: String? {
        switch self {
        case .results(let fetchResult):
            return "\(fetchResult.count) found"
        case .noResults:
            return "0 found"
        case .noQuery:
            return ""
        case .queryChanged, .fetchShouldStart, .definitionSelectionChanged, .fetchDidEnd:
            return nil
        }
    }
}
