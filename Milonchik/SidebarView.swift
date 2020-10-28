//
//  MLNSideBar.swift
//  Milonchik
//
//  Created by Roey Biran on 18/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

class SidebarView: NSSplitViewItem {
    override func awakeFromNib() {
        canCollapse = false
    }
}
