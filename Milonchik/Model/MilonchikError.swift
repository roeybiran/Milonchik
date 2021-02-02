import Foundation

enum MilonchikError: Error {
    // case SQLError(_: Error)
    // case genericError(message: String)
    enum HebrewSpellingInstallerError: Error {
        case spellingDirectoryAccessFailure
    }
}

enum GenericError: Error {
    case error(message: String)
}

enum DatabaseError: LocalizedError {
    case userCancelled
    case unknown
    case noDefinitions(for: Query)
}
