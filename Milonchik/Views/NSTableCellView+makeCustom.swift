import Cocoa

extension NSTableCellView {
  static func makeCustom(label: String, identifier: NSUserInterfaceItemIdentifier) -> NSTableCellView {
    let textField = NSTextField(string: label)
    textField.isBordered = false
    textField.backgroundColor = .clear
    textField.isEditable = false
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.lineBreakMode = .byTruncatingTail
    textField.usesSingleLineMode = true

    let newCell = NSTableCellView()
    newCell.textField = textField
    newCell.addSubview(textField)
    newCell.identifier = identifier

    var constraints = [
      textField.widthAnchor.constraint(equalTo: newCell.widthAnchor),
      textField.leadingAnchor.constraint(equalTo: newCell.leadingAnchor),
      textField.centerYAnchor.constraint(equalTo: newCell.centerYAnchor),
    ]

    if identifier == .groupRowCell {
      textField.textColor = .secondaryLabelColor
      textField.font = NSFont.systemFont(ofSize: 11)
      constraints[2] = textField.bottomAnchor.constraint(equalTo: newCell.bottomAnchor, constant: -2)
    }
    NSLayoutConstraint.activate(constraints)

    return newCell
  }
}
