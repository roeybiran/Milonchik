//
//  MLNError.swift
//  Milonchik
//
//  Created by Roey Biran on 12/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

enum MilonchikError: Error {
    case noDefinitions
    case SQLError(_: Error)
}
