//
//  MLNSideBar.swift
//  Milonchik
//
//  Created by Roey Biran on 18/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

class SideBar: NSSplitViewItem {
    // FIXME: bug - not respected when set from IB
    override func awakeFromNib() {
        canCollapse = false
    }
}
