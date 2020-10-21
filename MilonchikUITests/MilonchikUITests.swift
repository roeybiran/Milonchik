//
//  MilonchikUITests.swift
//  MilonchikUITests
//
//  Created by Roey Biran on 23/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import XCTest

class MilonchikUITests: XCTestCase {

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
        XCTAssertTrue(sut.webViews.staticTexts["ממרח תפוחים"].exists)
        // window title reflects search results
        XCTAssertTrue(sut.windows.firstMatch.title != "Milonchik")
        // navigation the table from the text field
        sut.typeKey(.downArrow, modifierFlags: .function)
        XCTAssertTrue(sut.staticTexts["גון ירוק תפוח"].exists)
    }

    func testFocusSearchWithHotkey() throws {
        sut.typeKey("f", modifierFlags: [.command, .alternate])
        XCTAssertTrue(sut.searchFields.firstMatch.isSelected)
    }

    func testTabbing() throws {
        sut.typeKey("t", modifierFlags: .command)
        XCTAssertTrue(sut.tabs.count > 1)
    }

    func testNoReloadContextMenu() throws {
        let webView = sut.webViews
        let placeholder = webView.staticTexts.firstMatch
        placeholder.coordinate(withNormalizedOffset: CGVector(dx: 5, dy: 5)).click()
        XCTAssertTrue(webView.menuItems.count == 0)
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
