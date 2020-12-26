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

    func test_fetchingDefinitions() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        var result: DatabaseResult!

        sut.fetch(query: "apple") {
            result = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        switch result {
        case .success(let result):
            let obtainedID = result.exactMatches.first!.id
            XCTAssertEqual(obtainedID, 2913)
        default:
            XCTFail("fetch test failed")
        }
    }

    func test_fetchingByInflectionsOrAlternateSpelling() throws {

        let expectation = XCTestExpectation(description: "database fetching")
        var result: DatabaseResult!

        sut.fetch(query: "advocates") {
            result = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        if case .success(let response) = result {
            let resultID = response.partialMatches.sorted(by: { $0.id < $1.id }).first!.id
            XCTAssertEqual(resultID, 961)
        } else {
            XCTFail("fetch test failed")
        }
    }

    func test_definitionsAreUnique() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        var result: DatabaseResult!

        sut.fetch(query: "advocates") {
            result = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        if case .success(let response) = result {
            let allIDs = response.allMatches.map { $0.id }
            let uniqueIDs = Set(allIDs)
            XCTAssertTrue(allIDs.count == uniqueIDs.count, "returned definitions are not unique")
        } else {
            XCTFail("fetch test failed")
        }
    }

    func test_fetchingPartialMatches() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        var result: DatabaseResult!

        sut.fetch(query: "cap") {
            result = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        if case .success(let response) = result {
            XCTAssertGreaterThan(response.partialMatches.count, 0)
        } else {
            XCTFail("fetch test failed")
        }
    }
}
