import Foundation

// MARK: - MilonchikError

enum MilonchikError: Error {
  // case SQLError(_: Error)
  // case genericError(message: String)
  enum HebrewSpellingInstallerError: Error {
    case spellingDirectoryAccessFailure
  }
}

// MARK: - GenericError

enum GenericError: Error {
  case error(message: String)
}

// MARK: - DatabaseError

enum DatabaseError: LocalizedError {
  case userCancelled
  case unknown
  case noDefinitions(for: Query)
}
