//
//  String+trimmedAndSplittedByTab.swift
//  Milonchik
//
//  Created by Roey Biran on 25/12/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

extension String {
    func trimmedAndSplittedByTab() -> [Substring] {
        self.split(separator: "\t")
    }
}
