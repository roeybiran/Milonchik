//

import XCTest

@testable import Milonchik

class DatabaseFetcherTests: XCTestCase {
    var sut: DatabaseFetcher!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DatabaseFetcher()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_fetch_withApple_shouldReturnID2913() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        var result: DatabaseResult!

        sut.fetch(query: "apple") {
            result = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        switch result {
        case let .success(result):
            let obtainedID = result.exactMatches.first!.id
            XCTAssertEqual(obtainedID, 2913)
        default:
            XCTFail("fetch test failed")
        }
    }

    func test_fetch_byInflectionsWithAdvocates_shouldReturnAdvocate() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        var result: DatabaseResult!

        sut.fetch(query: "advocates") {
            result = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        if case let .success(response) = result {
            let result = response.partialMatches.sorted(by: { $0.id < $1.id }).first!
            XCTAssertEqual(result.translatedWord, "advocate")
        } else {
            XCTFail("fetch test failed")
        }
    }

    func test_fetch_shouldReturnUniqueResults() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        var result: DatabaseResult!

        sut.fetch(query: "advocates") {
            result = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        if case let .success(response) = result {
            let allIDs = response.allMatches.map { $0.id }
            let uniqueIDs = Set(allIDs)
            XCTAssertEqual(allIDs.count, uniqueIDs.count)
        } else {
            XCTFail("fetch test failed")
        }
    }

    func test_fetch_withCap_shouldReturnPartialMatches() throws {
        let expectation = XCTestExpectation(description: "database fetching")
        var result: DatabaseResult!

        sut.fetch(query: "cap") {
            result = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        if case let .success(response) = result {
            XCTAssertGreaterThan(response.partialMatches.count, 0)
        } else {
            XCTFail("fetch test failed")
        }
    }
}
