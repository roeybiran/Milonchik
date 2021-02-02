//
//  WindowControllerTests.swift
//  MilonchikTests
//
//  Created by Roey Biran on 01/01/2021.
//  Copyright © 2021 Roey Biran. All rights reserved.
//

import XCTest

@testable import Milonchik

class MockNSApplication: NSApplication {
    override var currentEvent: NSEvent? {
        return NSEvent()
    }
}

class WindowControllerTests: XCTestCase {

    // var sut: WindowController!
    //
    // override func setUp() {
    //     super.setUp()
    //     sut = WindowController()
    // }
    //
    // override func tearDown() {
    //     sut = nil
    //     super.tearDown()
    // }
    //
    // func test_searchFieldDelegate_shouldExist() {
    //     XCTAssertNotNil(sut.searchField.delegate, "search field delegate")
    // }
    //
    // func test_searchFieldDelegate_withSpecificSelectors_shouldReturnTrue() {
    //     sut.selectors.forEach {
    //         XCTAssertEqual(doCommand(searchField: sut.searchField, selector: $0), true, "search field returned false for \($0)")
    //     }
    // }
    //
    // func test_searchField_withQuery_shouldChangeState() {
    //     sut.searchField.stringValue = "foo"
    //     sut.performSearch(nil)
    //
    //     // assert
    //     let state = sut.viewController.state
    //     if case .fetchShouldStart = state { return }
    //     XCTFail("expected: \(String(describing: State.fetchShouldStart)), got \(state)")
    // }

}
