//
//  NSTableCellView+makeCustom.swift
//  Milonchik
//
//  Created by Roey Biran on 15/12/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa

extension NSTableCellView {
    static func makeCustom(label: String) -> NSTableCellView {
        let textField = NSTextField(string: label)
        textField.isBordered = false
        textField.backgroundColor = .clear
        textField.isEditable = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.lineBreakMode = .byTruncatingTail
        textField.usesSingleLineMode = true
        let newCell = NSTableCellView()
        newCell.identifier = .tableCell
        newCell.textField = textField
        newCell.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalTo: newCell.widthAnchor),
            textField.leadingAnchor.constraint(equalTo: newCell.leadingAnchor),
            textField.centerYAnchor.constraint(equalTo: newCell.centerYAnchor)
        ])
        return newCell
    }
}
