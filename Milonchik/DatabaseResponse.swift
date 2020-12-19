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
    let count: Int
    let allMatches: [Definition]

    init(matches: [Definition], query: String) {
        self.allMatches = matches
        self.query = query
        self.count = matches.count
        self.exactMatches = matches.filter { $0.translatedWordSanitized == query }
        self.partialMatches = matches.filter { $0.translatedWordSanitized != query }
    }
}
