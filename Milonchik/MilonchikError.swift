//
//  MLNError.swift
//  Milonchik
//
//  Created by Roey Biran on 12/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

enum MilonchikError: Error {
    case userCancelled
    case noDefinitions(for: String)
    case SQLError(_: Error)
    // case genericError(message: String)
    enum HebrewSpellingInstallerError: Error {
        case spellingDirectoryAccessFailure
    }
}

enum GenericError: Error {
    case error(message: String)
}
