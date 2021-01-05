//
//  WindowControllerTests.swift
//  MilonchikTests
//
//  Created by Roey Biran on 01/01/2021.
//  Copyright © 2021 Roey Biran. All rights reserved.
//

import XCTest

@testable import Milonchik

class WindowControllerTests: XCTestCase {

    func test_windowController_shouldLoad() {
        let sut = WindowController()

        XCTAssertNotNil(sut, "Failed to load WindowController")
    }

    func test_searchField_withQuery_shouldChangeState() {
        // arrange
        let windowController = WindowController()
        let sut = windowController.searchField

        // act
        sut.stringValue = "foo"
        windowController.performSearch(nil)

        // assert
        let state = windowController.viewController.state
        if case State.fetchShouldStart = state { return }
        XCTFail("expected: \(String(describing: State.fetchShouldStart)), got \(state)")
    }

}
