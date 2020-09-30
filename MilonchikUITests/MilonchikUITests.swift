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

    func testTypingQueryAndSelectingDefinition() throws {
        let window = sut.children(matching: .window).firstMatch
        let searchSearchField = window.toolbars.searchFields.firstMatch
        searchSearchField.click()
        searchSearchField.typeText("apple")
        window/*@START_MENU_TOKEN@*/.tables.staticTexts["apple butter"]/*[[".splitGroups",".scrollViews.tables",".tableRows",".cells.staticTexts[\"apple butter\"]",".staticTexts[\"apple butter\"]",".tables"],[[[-1,5,2],[-1,1,2],[-1,0,1]],[[-1,5,2],[-1,1,2]],[[-1,4],[-1,3],[-1,2,3]],[[-1,4],[-1,3]]],[0,0]]@END_MENU_TOKEN@*/.click()
        window.splitGroups.children(matching: .group).element.click()
        XCTAssertTrue(window.webViews.staticTexts["ממרח תפוחים"].exists)
        // window title reflects search results
        XCTAssertTrue(window.title != "Milonchik")
        // navigation the table from the text field
        sut.typeKey(.downArrow, modifierFlags: .function)
        XCTAssertTrue(window.webViews.staticTexts["גון ירוק תפוח"].exists)
    }

    func testWindowTabbing() throws {
        // tabbing
        sut.typeKey("t", modifierFlags: .command)
        XCTAssertTrue(sut.tabs.count == 2)
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
