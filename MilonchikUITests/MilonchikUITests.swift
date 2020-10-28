//
//  MilonchikUITests.swift
//  MilonchikUITests
//
//  Created by Roey Biran on 23/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import XCTest

class MilonchikUITests: XCTestCase {

    // will fail if keyboard layout is not english!

    let sut = XCUIApplication()

    override func setUpWithError() throws {
        sut.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        sut.terminate()
    }

    func testSearchFlow() throws {
        let searchField = sut.searchFields.firstMatch
        searchField.click()
        searchField.typeText("apple")
        sut.staticTexts["apple butter"].click()
        XCTAssert(sut.webViews.staticTexts["ממרח תפוחים"].exists)
        // window title reflects search results
        XCTAssert(sut.windows.firstMatch.title != "Milonchik")
        // navigation the table from the text field
        sut.typeKey(.downArrow, modifierFlags: .function)
        XCTAssert(sut.staticTexts["גון ירוק תפוח"].exists)
    }

    func testFocusSearchWithHotkey() throws {
        sut.typeKey("f", modifierFlags: [.command, .alternate])
        sut.typeText("foo")
        // can't simply check for focus because rdar://49950847
        XCTAssertFalse((sut.searchFields.firstMatch.value as! String).isEmpty)

    }

    func testTabbing() throws {
        sut.typeKey("t", modifierFlags: .command)
        XCTAssert(sut.tabs.count > 1)
    }

    // func testLaunchPerformance() throws {
    //     if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
    //         // This measures how long it takes to launch your application.
    //         measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
    //             XCUIApplication().launch()
    //         }
    //     }
    // }
}
