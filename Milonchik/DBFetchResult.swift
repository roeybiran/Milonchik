//
//  DBFetchResult.swift
//  Milonchik
//
//  Created by Roey Biran on 26/10/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

/// Represents the result of a database fetch operation.
struct DBFetchResult {
    let exactMatches: [Definition]
    let partialMatches: [Definition]
    let query: String
    var count: Int {
        return exactMatches.count + partialMatches.count
    }
    var allMatches: [Definition] {
        return exactMatches + partialMatches
    }
}
