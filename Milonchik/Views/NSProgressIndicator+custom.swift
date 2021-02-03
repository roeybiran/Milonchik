import Cocoa

extension NSProgressIndicator {
    static func makeCustom() -> NSProgressIndicator {
        let indicator = NSProgressIndicator()
        indicator.controlSize = .small
        indicator.isIndeterminate = true
        indicator.style = .spinning
        indicator.isDisplayedWhenStopped = false
        return indicator
    }
}
