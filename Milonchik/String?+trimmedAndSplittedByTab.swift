//
//  String?+trimmedAndSplittedByTab.swift
//  Milonchik
//
//  Created by Roey Biran on 25/12/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    func trimmedAndSplittedByTab() -> [Substring] {
        self?.trimmedAndSplittedByTab() ?? []
    }
}
