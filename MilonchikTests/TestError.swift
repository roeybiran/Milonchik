//
//  TestError.swift
//  MilonchikTests
//
//  Created by Roey Biran on 09/01/2021.
//  Copyright © 2021 Roey Biran. All rights reserved.
//

import Foundation

struct TestError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}
