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
    // var mockedFetcher: MockDatabaseFetcher!

    override func setUpWithError() throws {
        try super.setUpWithError()
        // mockedFetcher = MockDatabaseFetcher()
        sut = ModelController(dbFetcher: MockDatabaseFetcher())
    }

    override func tearDownWithError() throws {
        sut = nil
        // mockedFetcher = nil
        try super.tearDownWithError()
    }

    func test() {
        let _expectation = expectation(description: "")
        var outcome: ModelController.ExternalState?
        sut.onStateChange = {
            outcome = $0
            _expectation.fulfill()
        }

        sut.mutate(into: .queryChanged(to: "foo"))

        wait(for: [_expectation], timeout: 0.1)
        if case .results = outcome {
            return
        }
        XCTFail("expected .results, got: \(String(describing: outcome.self))")
    }

}

struct MockDatabaseFetcher: DatabaseFetching {

    func cancelFetch() {}

    func fetch(query: String, completionHandler: @escaping (DatabaseResult) -> Void) {
        completionHandler(.success(mockDBResponse))
    }

    let mockDBResponse = DatabaseResponse(matches: [], query: "", sanitizedQuery: "")
}
