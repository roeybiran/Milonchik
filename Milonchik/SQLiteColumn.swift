//
//  SQLiteColumn.swift
//  Milonchik
//
//  Created by Roey Biran on 11/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Foundation

struct SQLiteColumn {
    enum Kind {
        case text, int
    }

    let kind: Kind
    let position: Int
}
