//
//  Constants.swift
//  Milonchik
//
//  Created by Roey Biran on 21/08/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

enum Constants {
    static let appName = "Milonchik"
}

extension NSNotification.Name {
    static let searchFieldKeyDown = NSNotification.Name("searchFieldKeyDown")
}

extension NSUserInterfaceItemIdentifier {
    static let primaryCellView = NSUserInterfaceItemIdentifier("DefinitionCell")
    static let suggestionCellView = NSUserInterfaceItemIdentifier("SuggestionCell")
}

extension NSStoryboard.SceneIdentifier {
    static let windowController = NSStoryboard.SceneIdentifier("WindowController")
}

extension NSWindow.FrameAutosaveName {
    static let mainWindow = NSWindow.FrameAutosaveName("MainWindow")
}

extension NSToolbarItem.Identifier {
    static let searchField = NSToolbarItem.Identifier("SearchField")
}
