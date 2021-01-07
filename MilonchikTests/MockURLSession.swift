//
//  MockURLSession.swift
//  MilonchikTests
//
//  Created by Roey Biran on 06/01/2021.
//  Copyright © 2021 Roey Biran. All rights reserved.
//

import Foundation

@testable import Milonchik

class MockURLSession: URLSessionProtocol {

    var taskCallCount = 0
    var acculumatedRequests = [URLRequest]()

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        taskCallCount += 1
        acculumatedRequests.append(request)
        return DummyURLSessionDataTask()
    }
}

private class DummyURLSessionDataTask: URLSessionDataTask {
    override func resume() {
    }
}
