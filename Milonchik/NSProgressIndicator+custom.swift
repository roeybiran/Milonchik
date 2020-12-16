//
//  NSProgressIndicator+custom.swift
//  Milonchik
//
//  Created by Roey Biran on 12/12/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

extension NSProgressIndicator {
    static var custom: NSProgressIndicator {
        let indicator = NSProgressIndicator()
        indicator.controlSize = .small
        indicator.isIndeterminate = true
        indicator.style = .spinning
        indicator.isDisplayedWhenStopped = false
        return indicator
    }
}
