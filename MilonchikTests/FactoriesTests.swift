//
//  FactoriesTests.swift
//  MilonchikTests
//
//  Created by Roey Biran on 25/12/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import XCTest

@testable import Milonchik
class FactoriesTests: XCTestCase {
    func test_makeCustom_shouldMakeRegularCell() {
        XCTAssertNotNil(NSTableCellView.makeCustom(label: "", identifier: .regularCell))
    }

    func test_makeCustom_shouldMakeGroupCell() {
        XCTAssertNotNil(NSTableCellView.makeCustom(label: "", identifier: .groupRowCell))
    }

    func test_makeCustom_shouldMakeScrollView() {
        XCTAssertNotNil(NSScrollView.makeCustom(enclosedTableView: NSTableView()))
    }

    func test_makeCustom_shouldMakeTableView() {
        XCTAssertNotNil(NSTableView.makeCustom())
    }

    func test_makeCustom_shouldMakeWindow() {
        XCTAssertNotNil(NSWindow.makeCustom(contentViewController: ViewController()))
    }
}
