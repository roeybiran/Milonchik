//
//  Array+Merged.swift
//  Milonchik
//
//  Created by Roey Biran on 15/09/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

extension Array where Element == DefinitionRaw {
    /// Consolidates an array of `DefinitionRaw` into an array of `Definition`.
    ///
    /// `DefinitionRaw` of the same ID that appear 2 times or more, represent a `Definition`with 2 or more of either of the following: `synonyms`, `inflections`, `samples` and/or `translations`. This method will merge the `DefinitionRaw` elements into a `Definition`, while deduplicating the aforementioned properties.
    ///
    /// - Returns:
    /// An array of consolidated `Definition`.
    /// - Note:
    /// Assumes the original array has its elements sorted by the `id` property.
    func merged() -> [Definition] {
        var nonRawDefinitions = [Definition]()
        for rawDefinition in self {
            if let lastWord = nonRawDefinitions.last, lastWord.id == rawDefinition.id {
                let newWord = lastWord.absorb(rawDefinition)
                nonRawDefinitions = nonRawDefinitions.dropLast()
                nonRawDefinitions.append(newWord)
            } else {
                nonRawDefinitions.append(Definition(rawDefinition))
            }
        }
        return nonRawDefinitions
    }
}
