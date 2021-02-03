import XCTest

@testable import Milonchik

class MorfixFetcherTests: XCTestCase {

    var sut: MorfixFetcher!
    let endpointURL = URL(string: "http://services.morfix.com/translationhebrew/TranslationService/GetTranslation/")!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)

        sut = MorfixFetcher()
        sut.session = mockSession
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_fetchResponse_withQuery_shouldReturnSuccess() {
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: self.endpointURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, self.jsonData())
        }
        let _expectation = expectation(description: "URLSessionExpectation")
        var result: Result<[MorfixDefinition], Error>!

        sut.fetch(query: "home", onCompletion: { fetchResult in
            result = fetchResult
            _expectation.fulfill()
        })
        waitForExpectations(timeout: 0.01)

        if case .success = result { return }
        XCTFail(self.name)
    }

    func test_fetchResponse_withQueryAndBadJSON_shouldReturnFailure() {
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: self.endpointURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, self.badJSONData())
        }
        let _expectation = expectation(description: "URLSessionExpectation")
        var result: Result<[MorfixDefinition], Error>!

        sut.fetch(query: "home", onCompletion: { fetchResult in
            result = fetchResult
            _expectation.fulfill()
        })
        waitForExpectations(timeout: 0.01)

        if case .failure(let error) = result, error is DecodingError { return }
        XCTFail("Result is not an error, or not an error of the expected type")
    }

    func test_fetchResponse_withURLSessionError_shouldReturnFailure() {
        let errorMessage = "Mock URLSession Error"
        MockURLProtocol.requestHandler = { _ in
            throw TestError(message: errorMessage)
        }
        let _expectation = expectation(description: "URLSessionExpectation")
        var result: Result<[MorfixDefinition], Error>!

        sut.fetch(query: "home", onCompletion: { fetchResult in
            result = fetchResult
            _expectation.fulfill()
        })
        waitForExpectations(timeout: 0.01)

        if case .failure(let error) = result, error.localizedDescription == "The operation couldn’t be completed. (MilonchikTests.TestError error 1.)" {
            return
        }
        XCTFail("Result is not an error, or not an error of the expected type")
    }
}

extension MorfixFetcherTests {
    func jsonData() -> Data? {
        guard let url = Bundle(for: MorfixFetcherTests.self).url(forResource: "ResponseJSON_Matches", withExtension: "json") else { return nil }
        return try? Data(contentsOf: url)
    }

    func badJSONData() -> Data? {
        guard let url = Bundle(for: MorfixFetcherTests.self).url(forResource: "ResponseJSON_Matches_MALFORMED", withExtension: "json") else { return nil }
        return try? Data(contentsOf: url)
    }

    func response(statusCode: Int) -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "http://DUMMY")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
}

// func test_fetchRequest_withHouseInSearchField_shouldCreateProperRequestAndCalledOnce() {
    // mockSession = MockURLSession()
    // sut.session = mockSession
    // sut.fetch(query: "House", onCompletion: { _ in })
    // let request = URLRequest(url: URL(string: "http://services.morfix.com/translationhebrew/TranslationService/GetTranslation/")!)
    // mockSession.verifyDataTask(with: request)
// }

// func test_fetch_withHouse_shouldReturnID46142() {
//     let expectation = XCTestExpectation(description: "")
//     sut.fetch(query: "house") { result in
//         switch result {
//         case .success(let definitions):
//             XCTAssertEqual(definitions.first?.id, 46142)
//         case .failure(let error):
//             XCTFail(error.localizedDescription)
//         }
//         expectation.fulfill()
//     }
//     wait(for: [expectation], timeout: 5)
// }
