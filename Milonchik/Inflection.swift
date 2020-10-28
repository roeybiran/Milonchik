//
//  Inflection.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

struct Inflection: Equatable, Codable, Hashable {
    let contents: String
    let kind: String

    enum CodingKeys: String, CodingKey {
        case kind = "Title"
        case contents = "Text"
    }
}

extension Inflection {
    init?(contents: String?, kind: String?) {
        guard let contents = contents, let kind = kind else { return nil }
        self.contents = contents
        self.kind = kind
    }
}
