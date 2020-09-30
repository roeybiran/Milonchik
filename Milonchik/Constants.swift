//
//  Constants.swift
//  Milonchik
//
//  Created by Roey Biran on 21/08/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

extension NSNotification.Name {
    static let searchFieldKeyDown = NSNotification.Name("searchFieldKeyDown")
}

extension NSUserInterfaceItemIdentifier {
    static let tableCellView = NSUserInterfaceItemIdentifier("TableCellView")
}

extension NSStoryboard.SceneIdentifier {
    static let windowController = NSStoryboard.SceneIdentifier("WindowController")
}

extension String {
    static let appName = "Milonchik"
}
