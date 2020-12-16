// //
// //  NetworkController.swift
// //  Milonchik
// //
// //  Created by Roey Biran on 18/09/2020.
// //  Copyright © 2020 Roey Biran. All rights reserved.
// //
// 
// import Foundation
// 
// // /[`~!@#$%^&*()_|+=?;:'",.<>{}[\]/\\]/gi,
// 
// class NetworkController {
//     let url = "http://services.morfix.com/translationhebrew/TranslationService/GetTranslation/"
// }
// 
// struct MorfixResult: Codable {
//     enum MorfixResultType: String, Codable {
//         case match = "Match", noResults = "NoResult"
//     }
// 
//     let resultType: MorfixResultType
//     let words: [MorfixWord]
// 
//     enum CodingKeys: String, CodingKey {
//         case words = "Words"
//         case resultType = "ResultType"
//     }
// }
// 
// struct MorfixWord: Codable {
//     let id: Int
//     let translations: [[MorfixTranslation]]
//     let partOfSpeech: String
//     let inflections: [Inflection]
//     let samples: [String]
//     let synonyms: [String]
//     enum CodingKeys: String, CodingKey {
//         case id = "ID"
//         case translations = "OutputLanguageMeanings"
//         case partOfSpeech = "PartOfSpeech"
//         case inflections = "Inflections"
//         case samples = "SampleSentences"
//         case synonyms = "SynonymsList"
//     }
// }
// 
// struct MorfixTranslation: Codable {
//     let displayText: String
//     let translation: String
//     enum CodingKeys: String, CodingKey {
//         case displayText = "DisplayText"
//         case translation = "Translation"
//     }
// }
