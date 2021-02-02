import Cocoa

extension NSWindow {
    static func makeCustom(contentViewController: NSViewController) -> NSWindow {
        let window = NSWindow(contentViewController: contentViewController)
        window.styleMask = [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView]
        window.title = Constants.appName
        window.minSize = CGSize(width: 400, height: 300)
        return window
    }
}
