import XCTest

@testable import Milonchik

class MorfixControllerTests: XCTestCase {

    var sut: MorfixController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MorfixController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_fetch_withHouse_shouldReturnID46142() {
        let expectation = XCTestExpectation(description: "")
        sut.fetch(query: "house") { result in
            switch result {
            case .success(let definitions):
                XCTAssertEqual(definitions.first?.id, 46142)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

}
