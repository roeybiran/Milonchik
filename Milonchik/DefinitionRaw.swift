//
//  DefinitionRaw.swift
//  Milonchik
//
//  Created by Roey Biran on 17/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

struct DefinitionRaw: Comparable {
    let id: Int
    let translatedWord: String
    let translation: String
    let partOfSpeech: String?
    let synonym: String?
    let inflectionKind: String?
    let inflectionValue: String?
    let sample: String?
    let translatedLanguage: InputLanguage
    let translatedWordSanitized: String

    static func < (lhs: DefinitionRaw, rhs: DefinitionRaw) -> Bool {
        return lhs.id < rhs.id
    }
}
