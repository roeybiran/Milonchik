//
//  MockURLSession.swift
//  MilonchikTests
//
//  Created by Roey Biran on 06/01/2021.
//  Copyright © 2021 Roey Biran. All rights reserved.
//

import Foundation
import XCTest

@testable import Milonchik

class MockURLSession: URLSessionProtocol {

    var taskCallCount = 0
    var acculumatedRequests = [URLRequest]()
    var completionHandlers = [(Data?, URLResponse?, Error?) -> Void]()

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        taskCallCount += 1
        acculumatedRequests.append(request)
        completionHandlers.append(completionHandler)
        return DummyURLSessionDataTask()
    }

    func verifyDataTask(with request: URLRequest, file: StaticString = #file, line: UInt = #line) {
        if !dataTaskWasCalledOnce(file: file, line: line) { return }
        XCTAssertEqual(acculumatedRequests.first?.url, request.url, "request", file: file, line: line)
    }

    func dataTaskWasCalledOnce(file: StaticString = #file, line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName: "dataTask(with:completionHandler:)",
            callCount: taskCallCount,
            describeArguments: "request: \(acculumatedRequests)",
            file: file,
            line: line
        )
    }
}

private class DummyURLSessionDataTask: URLSessionDataTask {
    override func resume() {
    }
}

func verifyMethodCalledOnce(
    methodName: String,
    callCount: Int,
    describeArguments: @autoclosure () -> String,
    file: StaticString = #file,
    line: UInt = #line) -> Bool {
    if callCount == 0 {
        XCTFail("Wanted but not invoked: \(methodName)", file: file, line: line)
        return false
    }
    if callCount > 1 {
        XCTFail("Wanted 1 time but was called \(callCount) times. \(methodName) with \(describeArguments())", file: file, line: line)
        return false
    }
    return true
}
