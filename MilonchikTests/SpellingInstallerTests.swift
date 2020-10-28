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

        let fm = FileManager.default
        let spellFolder = fm
            .urls(for: .libraryDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Spelling", isDirectory: true)
        [("he_IL", "aff"), ("he_IL", "dic")].forEach({
            let path = spellFolder.appendingPathComponent($0.0).appendingPathExtension($0.1)
            XCTAssertTrue(fm.fileExists(atPath: path.path))
        })
    }
}
