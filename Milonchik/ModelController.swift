//
//  WordModelController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa
import SQLite

private enum Tables {
    static let definitions = Table("definitions")
    static let inflections = Table("inflections")
    static let translations = Table("translations")
    static let synonyms = Table("synonyms")
    static let samples = Table("samples")
}

private enum Columns {
    static let sanitizedWord = Expression<String>("sanitized_input_word")
    static let id = Expression<Int64>("id")
    static let inputLanguage = Expression<String>("input_lang")
    static let inputWord = Expression<String>("input_word")
    static let partOfSpeech = Expression<String?>("part_of_speech")
    static let translation = Expression<String>("translation")
    static let inflectionKind = Expression<String?>("inflection_kind")
    static let inflectionValue = Expression<String?>("inflection_value")
    static let synonym = Expression<String?>("synonym")
    static let sample = Expression<String?>("sample")
}

final class ModelController {

    private let queue = OperationQueue()
    private let database: Connection

    init() {
        queue.qualityOfService = .userInteractive
        let databasePath = Bundle.main.path(forResource: "milon", ofType: "db")!
        guard let database = try? Connection(databasePath, readonly: true) else {
            preconditionFailure("Database is missing or corrupt")
        }
        self.database = database
    }

    func cancelFetch() {
        queue.cancelAllOperations()
    }

    func fetch(query: String, completionHandler: @escaping (Swift.Result<[Definition], MilonchikError>) -> Void) {
        let query = query.replacingOccurrences(of: "(?=%|_)", with: #"\\"#, options: .regularExpression)
        let operation = DatabaseOperation(database: database, query: "\(query)%")
        operation.completionBlock = { [unowned operation] in
            if operation.isCancelled { return }
            completionHandler(operation.result)
        }
        queue.addOperation(operation)
    }
}

private class DatabaseOperation: Operation {

    private let database: Connection
    private let query: String

    var result: (Swift.Result<[Definition], MilonchikError>)!

    init(database: Connection, query: String) {
        self.database = database
        self.query = query
        super.init()
    }

    //FIXME: upon cancellations, consider returning setting `result` to MilonchikError.cancelled
    override func main() {

        // if isCancelled { return }
        // let speller = NSSpellChecker.shared
        // let range = NSRange(query.startIndex..<query.endIndex, in: query)
        // let guesses = ["en", "he_IL"]
        //     .compactMap({
        //         speller.guesses(forWordRange: range, in: query, language: $0, inSpellDocumentWithTag: 0) ?? []
        //     }).reduce([], +)

        if isCancelled { return }
        let statement = Tables.definitions.select(
            Tables.definitions[Columns.id],
            Columns.inputLanguage,
            Columns.inputWord,
            Columns.partOfSpeech,
            Columns.inflectionKind,
            Columns.inflectionValue,
            Columns.synonym,
            Columns.translation,
            Columns.sample)
            .join(.leftOuter, Tables.inflections, on: Tables.definitions[Columns.id] == Tables.inflections[Columns.id])
            .join(.leftOuter, Tables.translations, on: Tables.definitions[Columns.id] == Tables.translations[Columns.id])
            .join(.leftOuter, Tables.synonyms, on: Tables.definitions[Columns.id] == Tables.synonyms[Columns.id])
            .join(.leftOuter, Tables.samples, on: Tables.definitions[Columns.id] == Tables.samples[Columns.id])
            .filter(
                Tables.definitions[Columns.sanitizedWord].like(query, escape: "\\") ||
                Tables.inflections[Columns.inflectionValue].like(query, escape: "\\")
            )
            .limit(query.count * 10)
            .order(Tables.definitions[Columns.id])
        if isCancelled { return }
        do {
            let results = try database.prepare(statement)
            if isCancelled { return }
            let definitions = results.map({ makeRawDefinition(row: $0) }).merged()
            if definitions.isEmpty {
                result = .failure(.noDefinitions)
            } else {
                result = .success(definitions)
            }
        } catch {
            result = .failure(.SQLError(error))
        }
     }

    func makeRawDefinition(row: Row) -> DefinitionRaw {
        return DefinitionRaw(id: Int(row[Columns.id]),
                             word: row[Columns.inputWord],
                             translation: row[Columns.translation],
                             partOfSpeech: row[Columns.partOfSpeech],
                             synonym: row[Columns.synonym],
                             inflectionKind: row[Columns.inflectionKind],
                             inflectionValue: row[Columns.inflectionValue],
                             sample: row[Columns.sample],
                             inputLanguage: InputLanguage(rawValue: row[Columns.inputLanguage])!)
    }
}
