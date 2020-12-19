//
//  WordModelController.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa
import SQLite

typealias DatabaseResult = Swift.Result<DatabaseResponse, MilonchikError>

final class ModelController {

    private let queue = OperationQueue()
    private let database: Connection

    init() {
        queue.qualityOfService = .userInteractive

        guard
            let databasePath = Bundle.main.path(forResource: "milon", ofType: "db"),
            let database = try? Connection(databasePath, readonly: true) else {
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
        let sanitizedQuery = "\(query.replacingOccurrences(of: "(?=%|_)", with: #"\\"#, options: .regularExpression))"
        let statement = Tables.definitions.select(
            Columns.id,
            Columns.translatedWordSanitized,
            Columns.translatedLanguage,
            Columns.translatedWord,
            Columns.partOfSpeech,
            Columns.inflectionKind,
            Columns.inflectionValue,
            Columns.synonyms,
            Columns.translations,
            Columns.samples,
            Columns.alternateSpellings
        ).filter(
                Columns.translatedWordSanitized.like("\(sanitizedQuery)%", escape: "\\") ||
                Columns.inflectionValue.like("%\(sanitizedQuery)%", escape: "\\") ||
                Columns.alternateSpellings.like(sanitizedQuery, escape: "\\") ||
                guesses(for: query).contains(Columns.translatedWordSanitized)
            )
            .order(Columns.translatedWordSanitized)
        do {
            let results = try Set(database.prepare(statement).map{ Definition($0) }).sorted {
                switch ($0.translatedWordSanitized.starts(with: query), $1.translatedWordSanitized.starts(with: query)) {
                case (true, false):
                    return true
                case (false, true):
                    return false
                default:
                    return $0.translatedWordSanitized < $1.translatedWordSanitized
                }
            }

            if isCancelled { return }
            if results.count == 0 {
                result = .failure(.noDefinitions(for: query))
            } else {
                result = .success(DatabaseResponse(matches: results, query: query))
            }
        } catch {
            result = .failure(.SQLError(error))
        }

    }

    private func guesses(for q: String) -> [String] {
        let range = NSRange(q.startIndex..<q.endIndex, in: q)
        let guesses = NSSpellChecker.shared.guesses
        return ["en", "he_IL"].compactMap({ guesses(range, q, $0, 0) ?? [] }).reduce([], +)
    }
}

enum Tables {
    static let definitions = Table("definitions")
}

enum Columns {
    static let id = Expression<Int64>("id")
    static let translatedLanguage = Expression<String>("translated_lang")
    static let translatedWord = Expression<String>("translated_word")
    static let translatedWordSanitized = Expression<String>("translated_word_sanitized")
    static let partOfSpeech = Expression<String?>("part_of_speech")
    static let synonyms = Expression<String?>("synonyms")
    static let translations = Expression<String>("translations")
    static let samples = Expression<String?>("samples")
    static let inflectionKind = Expression<String?>("inflection_kind")
    static let inflectionValue = Expression<String?>("inflection_value")
    static let alternateSpellings = Expression<String?>("alternate_spellings")
}
