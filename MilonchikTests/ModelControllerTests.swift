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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ModelController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testAsyncFetchedDefinitionMatchesExpected() throws {
        let expectedID = 2914
        let expectation = XCTestExpectation(description: "database fetching")
        sut.fetch(query: "apple%") { result in
            switch result {
            case .success(let definitions):
                let fetchedID = definitions.first!.id
                XCTAssertTrue(fetchedID == expectedID, "expected \(expectedID), received \(fetchedID)")
                expectation.fulfill()
            default:
                XCTFail("fetch test failed")
            }
        }
        wait(for: [expectation], timeout: 2)
    }

}
