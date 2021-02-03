import AppKit.NSSpellChecker
import Foundation
import SQLite

typealias DatabaseResult = Swift.Result<DatabaseResponse, Error>

struct DatabaseFetcher: DatabaseFetching {
    private let queue = OperationQueue()
    private let database: Connection
    private let speller: NSSpellChecker

    init(dbName: String = "milon", dbExtension: String = "db", bundle: Bundle = .main, speller: NSSpellChecker = .shared) {
        self.speller = speller
        guard
            let databasePath = bundle.path(forResource: dbName, ofType: dbExtension),
            let database = try? Connection(databasePath, readonly: true)
        else {
            preconditionFailure("Database missing or corrupt")
        }
        self.database = database

        queue.qualityOfService = .userInteractive
    }

    func cancelFetch() {
        queue.cancelAllOperations()
    }

    func fetch(query: String, completionHandler: @escaping (DatabaseResult) -> Void) {
        let operation = DatabaseOperation(database: database, query: query, speller: speller)
        operation.completionBlock = {
            completionHandler(operation.isCancelled ? .failure(DatabaseError.userCancelled) : operation.result)
        }
        queue.addOperation(operation)
    }
}

private class DatabaseOperation: Operation {
    var result: DatabaseResult = .failure(DatabaseError.unknown)

    private let database: Connection
    private let query: String
    private let spellChecker: NSSpellChecker

    init(database: Connection, query: String, speller: NSSpellChecker) {
        self.database = database
        self.query = query
        spellChecker = speller
    }

    override func main() {
        if isCancelled { return }
        let sanitizedQuery = query
            .replacingOccurrences(of: #"[^\s\u05D0-\u05DF\u05E0-\u05EAA-Za-z]"#, with: "", options: .regularExpression)
            .lowercased()
        if sanitizedQuery.isEmpty {
            result = .failure(DatabaseError.noDefinitions(for: query))
            return
        }
        let statement = makeStatement(query: sanitizedQuery, speller: spellChecker)
        do {
            let results = try Set(database.prepare(statement).map { Definition($0) }).sortedByRelevance(to: sanitizedQuery)
            if isCancelled { return }
            if results.count == 0 {
                result = .failure(DatabaseError.noDefinitions(for: query))
            } else {
                result = .success(DatabaseResponse(matches: results, query: query, sanitizedQuery: sanitizedQuery))
            }
        } catch {
            result = .failure(error)
        }
    }

    private func makeStatement(query: String, speller: NSSpellChecker) -> Table {
        Tables.definitions.select(
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
            Columns.translatedWordSanitized.like("\(query)%", escape: "\\") ||
                Columns.inflectionValue.like("%\(query)%", escape: "\\") ||
                Columns.alternateSpellings.like(query, escape: "\\") ||
                guesses(for: query, speller: speller).contains(Columns.translatedWordSanitized)
        )
        .order(Columns.translatedWordSanitized)
        .limit(1000)
    }

    private func guesses(for q: String, speller: NSSpellChecker) -> [String] {
        if !NSSpellChecker.sharedSpellCheckerExists { return [] }
        let range = NSRange(q.startIndex ..< q.endIndex, in: q)
        return ["en", "he_IL"]
            .compactMap {
                speller.guesses(forWordRange: range, in: q, language: $0, inSpellDocumentWithTag: 0)
            }
            .reduce([], +)
    }
}
