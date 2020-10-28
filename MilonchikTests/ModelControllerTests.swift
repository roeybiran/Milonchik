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
            case .success(let result):
                let expectedID = 2913
                let obtainedID = result.exactMatches.first!.id
                XCTAssertTrue(obtainedID == expectedID, "error: got id \(obtainedID), expected \(expectedID)")
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
            case .success(let result):
                let expectedID = 961
                let resultID = result.exactMatches.first!.id
                XCTAssertTrue(resultID == expectedID, "fail: got ID \(resultID), expected \(expectedID)")
                expectation.fulfill()
            default:
                XCTFail("fetch test failed")
            }
        }
        wait(for: [expectation], timeout: 3)
    }

    func testDefinitionsAreUnique() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        sut.fetch(query: "advocates") { result in
            switch result {
            case .success(let result):
                let allIDs = result.allMatches.map({ return $0.id })
                let uniqueIDs = Set(allIDs)
                XCTAssertTrue(allIDs.count == uniqueIDs.count)
                expectation.fulfill()
            default:
                XCTFail("fetch test failed")
            }
        }
        wait(for: [expectation], timeout: 3)
    }

    func testFetchingPartialMatches() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        sut.fetch(query: "cap") { result in
            switch result {
            case .success(let result):
                XCTAssertTrue(!result.exactMatches.isEmpty && !result.partialMatches.isEmpty)
                expectation.fulfill()
            default:
                XCTFail("fetch test failed")
            }
        }
        wait(for: [expectation], timeout: 2)
    }

}
