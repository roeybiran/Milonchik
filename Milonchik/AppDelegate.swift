import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let windowManager = WindowManager()

  func applicationDidFinishLaunching(_: Notification) {
    try? SpellingInstaller().install()
    windowManager.makeNewWindow(tabbed: false)
    NSApp.servicesProvider = windowManager
  }

  func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag { windowManager.makeNewWindow(tabbed: false) }
    return true
  }

  @IBAction
  func newWindowForTab(_: Any?) {
    windowManager.makeNewWindow(tabbed: true)
  }

  @IBAction
  func newWindow(_: Any?) {
    windowManager.makeNewWindow(tabbed: false)
  }
}
