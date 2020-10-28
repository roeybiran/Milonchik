//
//  WordModelController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa
import SQLite

final class ModelController {

    private let queue = OperationQueue()
    private let database: Connection

    init() {
        queue.qualityOfService = .userInteractive
        let databasePath = Bundle.main.path(forResource: "milon", ofType: "db")!
        guard let database = try? Connection(databasePath, readonly: true) else {
            preconditionFailure("Database missing or corrupt")
        }
        self.database = database
    }

    func cancelFetch() {
        queue.cancelAllOperations()
    }

    func fetch(query: String, completionHandler: @escaping (DatabaseResult) -> Void) {
        let operation = DatabaseOperation(database: database, query: query)
        operation.completionBlock = { [unowned operation] in
            completionHandler(operation.isCancelled ? .failure(.userCancelled) : operation.result)
        }
        queue.addOperation(operation)
    }
}

private class DatabaseOperation: Operation {

    var result: DatabaseResult!

    private let database: Connection
    private let query: String

    init(database: Connection, query: String) {
        self.database = database
        self.query = query
        super.init()
    }

    //FIXME: upon cancellations, consider returning setting `result` to MilonchikError.cancelled
    override func main() {
        if isCancelled { return }
        let pattern = "\(query.replacingOccurrences(of: "(?=%|_)", with: #"\\"#, options: .regularExpression))%"
        let baseStatement = makeBaseStatement()
        let exactMatchesStatement = baseStatement.filter(
            Tables.definitions[Columns.sanitizedWord].like(pattern, escape: "\\") ||
            Tables.inflections[Columns.inflectionValue].like(pattern, escape: "\\") ||
            Tables.alternateSpellings[Columns.alternateSpelling] == query
        )

        do {
            let exactMatches = try execute(query: pattern, statement: exactMatchesStatement)

            // partial matches/suggestions
            var partialMatches = [Definition]()
            if exactMatches.count < 5 {
                let partialMatchesStatement = baseStatement.filter(
                    guesses(for: pattern).contains(Tables.definitions[Columns.sanitizedWord]) &&
                    /* deduplication! */
                    !exactMatches.map({ Int64($0.id) }).contains(Tables.definitions[Columns.id])
                )
                partialMatches = try execute(query: pattern, statement: partialMatchesStatement)
            }

            let fetchResult = DBFetchResult(exactMatches: exactMatches, partialMatches: partialMatches, query: query)

            if isCancelled { return }
            if fetchResult.count == 0 {
                result = .failure(.noDefinitions(for: query))
            } else {
                result = .success(fetchResult)
            }
        } catch {
            result = .failure(.SQLError(error))
        }
    }

    private func execute(query: String, statement: Table) throws -> [Definition] {
        return try database
            .prepare(statement
                .limit(query.count * 10)
                .order(Tables.definitions[Columns.id]))
                .map({ makeRawDefinition(row: $0) })
            .merged()
    }

    private func guesses(for query: String) -> [String] {
        let range = NSRange(query.startIndex..<query.endIndex, in: query)
        return ["en", "he_IL"]
            .compactMap({
                NSSpellChecker
                .shared
                .guesses(forWordRange: range, in: query, language: $0, inSpellDocumentWithTag: 0) ?? []
            })
            .reduce([], +)
    }

    private func makeBaseStatement() -> Table {
        return Tables.definitions.select(
            Tables.definitions[Columns.id],
            Columns.inputLanguage,
            Columns.inputWord,
            Columns.partOfSpeech,
            Columns.inflectionKind,
            Columns.inflectionValue,
            Columns.synonym,
            Columns.translation,
            Columns.sample,
            Columns.alternateSpelling)
            .join(.leftOuter, Tables.inflections, on: Tables.definitions[Columns.id] == Tables.inflections[Columns.id])
            .join(.leftOuter, Tables.translations, on: Tables.definitions[Columns.id] == Tables.translations[Columns.id])
            .join(.leftOuter, Tables.synonyms, on: Tables.definitions[Columns.id] == Tables.synonyms[Columns.id])
            .join(.leftOuter, Tables.samples, on: Tables.definitions[Columns.id] == Tables.samples[Columns.id])
            .join(.leftOuter, Tables.alternateSpellings, on: Tables.definitions[Columns.id] == Tables.alternateSpellings[Columns.id])
    }

    private func makeRawDefinition(row: Row) -> DefinitionRaw {
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

private enum Tables {
    static let definitions = Table("definitions")
    static let inflections = Table("inflections")
    static let translations = Table("translations")
    static let synonyms = Table("synonyms")
    static let samples = Table("samples")
    static let alternateSpellings = Table("alternate_spellings")
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
    static let alternateSpelling = Expression<String?>("spelling")
}

typealias DatabaseResult = Swift.Result<DBFetchResult, MilonchikError>
