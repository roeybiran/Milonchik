//
//  TestHelpers.swift
//  MilonchikTests
//
//  Created by Roey Biran on 12/01/2021.
//  Copyright © 2021 Roey Biran. All rights reserved.
//

import Cocoa

func doCommand(searchField: NSSearchField, selector: Selector) -> Bool? {
    searchField.delegate?.control?(NSControl(), textView: NSTextView(), doCommandBy: selector)
}

func numberOfRows(in tableView: NSTableView) -> Int? {
    tableView.dataSource?.numberOfRows?(in: tableView)
}
