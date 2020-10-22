//
//  ModelControllerTests.swift
//  MilonchikTests
//
//  Created by Roey Biran on 11/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import XCTest

@testable import Milonchik
class SpellingInstallerTests: XCTestCase {
    func testSpellingInstaller() throws {
        XCTAssertNoThrow(try HebrewSpellingInstaller().install())
    }
}
