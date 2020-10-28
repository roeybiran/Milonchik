//
//  Array+Extension.swift
//  Milonchik
//
//  Created by Roey Biran on 17/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func uniqified() -> [Element] {
        return self.reduce([]) { (a: [Element], b: Element) -> [Element] in
            if a.contains(b) {
                return a
            }
            return a + [b]
        }
    }
}
