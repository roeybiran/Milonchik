//
//  ModelControllerTests.swift
//  MilonchikTests
//
//  Created by Roey Biran on 11/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import XCTest

@testable import Milonchik
class ModelControllerTests: XCTestCase {

    var sut: ModelController!

    override func setUpWithError() throws {
        sut = ModelController()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFetchingDefinitions() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        sut.fetch(query: "apple") { result in
            switch result {
            case .success(let definitions):
                let firstFetchedIDMatchesExpectedID = definitions.first!.id == 2914
                XCTAssertTrue(firstFetchedIDMatchesExpectedID)
                expectation.fulfill()
            default:
                XCTFail("fetch test failed")
            }
        }
        wait(for: [expectation], timeout: 2)
    }

    func testFetchByInflectionsOrAlternateSpelling() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        sut.fetch(query: "advocates") { result in
            switch result {
            case .success(let definitions):
                let expectedID = 962
                XCTAssertTrue(definitions.first!.id == expectedID, "first fetched ID should match \(expectedID)")
                expectation.fulfill()
            default:
                XCTFail("fetch test failed")
            }
        }
        wait(for: [expectation], timeout: 2)
    }

}
