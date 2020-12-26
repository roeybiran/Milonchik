//
//  DBFetchResult.swift
//  Milonchik
//
//  Created by Roey Biran on 26/10/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

/// Represents the result of a database fetch operation.
struct DatabaseResponse {
    let exactMatches: [Definition]
    let partialMatches: [Definition]
    let query: String
    let sanitizedQuery: String
    let count: Int
    let allMatches: [Definition]

    init(matches: [Definition], query: String, sanitizedQuery: String) {
        self.allMatches = matches
        self.query = query
        self.sanitizedQuery = sanitizedQuery
        self.count = matches.count
        self.exactMatches = matches.filter { $0.translatedWordSanitized == sanitizedQuery }
        self.partialMatches = matches.filter { $0.translatedWordSanitized != sanitizedQuery }
    }
}
