//
//  Definition.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

struct Definition: Comparable {
    let id: Int
    let inputWord: String
    let translations: [String]
    let partOfSpeech: String?
    let synonyms: [String]
    let samples: [String]
    let inflections: [Inflection]
    let inputLanguage: InputLanguage

    static func < (lhs: Definition, rhs: Definition) -> Bool {
        return lhs.id < rhs.id
    }
}

extension Definition {
    init(_ raw: DefinitionRaw) {
        self.id = raw.id
        self.inputWord = raw.word
        self.translations = [raw.translation]
        self.partOfSpeech = raw.partOfSpeech
        if let synonym = raw.synonym {
            self.synonyms = [synonym]
        } else {
            self.synonyms = []
        }
        if let sample = raw.sample {
            self.samples = [sample]
        } else {
            self.samples = []
        }
        if let inflectionKind = raw.inflectionKind, let inflectionValue = raw.inflectionValue {
            self.inflections = [Inflection(contents: inflectionValue, kind: inflectionKind)]
        } else {
            self.inflections = []
        }
        self.inputLanguage = raw.inputLanguage
    }
}

extension Definition {
    func absorb(_ rawDefinition: DefinitionRaw) -> Definition {
        let translations = self.translations + [rawDefinition.translation]

        var inflections = self.inflections
        if let inflectionKind = rawDefinition.inflectionKind, let inflectionValue = rawDefinition.inflectionValue {
            inflections.append(Inflection(contents: inflectionValue, kind: inflectionKind))
        }

        var samples = self.samples
        if let sample = rawDefinition.sample {
            samples.append(sample)
        }
        var synonyms = self.synonyms
        if let synonym = rawDefinition.synonym {
            synonyms.append(synonym)
        }

        return Definition(id: self.id, inputWord: self.inputWord, translations: translations.uniqified(),
                          partOfSpeech: self.partOfSpeech, synonyms: synonyms.uniqified(), samples: samples.uniqified(),
                          inflections: inflections.uniqified(), inputLanguage: self.inputLanguage)
    }
}
