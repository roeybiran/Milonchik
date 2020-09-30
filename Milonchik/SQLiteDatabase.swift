//
//  SQLiteDatabase.swift
//  Milonchik
//
//  Created by Roey Biran on 10/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
    case openDatabase(message: String)
    case prepare(message: String)
    case step(message: String)
    case bind(message: String)
}

typealias SQLiteStatement = OpaquePointer

final class SQLiteDatabase {

    private let dbPointer: OpaquePointer?

    fileprivate var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error msg provided from sqlite."
        }
    }

    deinit {
        sqlite3_close(dbPointer)
    }

    init(path: String) throws {
        var databasePointer: OpaquePointer?
        if sqlite3_open(path, &databasePointer) == SQLITE_OK {
            // return SQLiteDatabase(dbPointer: databasePointer)
            self.dbPointer = databasePointer
            return
        }
        defer {
            if databasePointer != nil {
                sqlite3_close(databasePointer)
            }
        }
        if let errorPointer = sqlite3_errmsg(databasePointer) {
            let message = String(cString: errorPointer)
            throw SQLiteError.openDatabase(message: message)
        }
        throw SQLiteError.openDatabase(message: "No error message provided from sqlite.")
    }
}

// MARK: - Preparing Statements
extension SQLiteDatabase {

    func prepare(statement: String) throws -> SQLiteStatement? {
        var sqlStatement: SQLiteStatement?
        guard sqlite3_prepare_v2(self.dbPointer, statement, -1, &sqlStatement, nil) == SQLITE_OK else {
            throw SQLiteError.prepare(message: errorMessage)
        }
        return sqlStatement
    }

    func bind(text: String, to statement: SQLiteStatement) throws -> SQLiteStatement {
        guard sqlite3_bind_text(statement, 1, NSString(string: text).utf8String, -1, nil) == SQLITE_OK else {
            throw SQLiteError.bind(message: errorMessage)
        }
        return statement
    }

    func execute<T>(statement: SQLiteStatement, columns: [SQLiteColumn]) throws -> [T] {
        var results: [T] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            for column in columns {
                let columnPosition = Int32(column.position)
                switch column.kind {
                case .int:
                    // results.append(Int(sqlite3_column_int(statement, columnPosition)) as! T)
                    print(Int(sqlite3_column_int(statement, columnPosition)))
                case .text:
                    print(String(cString: sqlite3_column_text(statement, columnPosition)))
                    // results.append(String(cString: sqlite3_column_text(statement, columnPosition)) as! T)
                }
            }
        }
        sqlite3_finalize(statement)
        return results
    }
}
