//
//  ViewControllerTests.swift
//  MilonchikTests
//
//  Created by Roey Biran on 28/12/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import XCTest

@testable import Milonchik
class ViewControllerTests: XCTestCase {

    var sut: ViewController!

    override func setUpWithError() throws {
        sut = ViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_viewController_shouldLoadView() {
        XCTAssertTrue(sut.view is NSSplitView)
    }

    // func test_toggleSidebarMenuItem_shouldCollapseSidebar() {
    //     sut.loadView()
    //     print(sut.splitViewItems.first?.isCollapsed ?? "")
    //     sut.toggleSidebar(nil)
    //     print(sut.splitViewItems.first?.isCollapsed ?? "")
    // }
}
