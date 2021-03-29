import AppKit

// MARK: - WindowManager

class WindowManager: NSResponder {
  var managedWindowControllers = [WindowController]()

  func makeNewWindow(tabbed: Bool) {
    let windowController = WindowController(tabbed: tabbed)
    windowController.window?.delegate = self
    managedWindowControllers.append(windowController)
  }

  @objc
  func defineInMilonchikServiceHandler(_ pboard: NSPasteboard, userData _: String, error _: NSErrorPointer) {
    // checking for NSApp.windows.isEmpty returns false if the About window is open
    if managedWindowControllers.isEmpty { makeNewWindow(tabbed: false) }

    guard
      let firstWindow = NSApp.orderedWindows.first,
      let controller = managedWindowControllers.first(where: { $0.window === firstWindow }),
      let text = pboard.string(forType: .string)
    else {
      return
    }
    controller.performSearch(text)
  }
}

// MARK: NSWindowDelegate

extension WindowManager: NSWindowDelegate {
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    managedWindowControllers.removeAll(where: { $0.window === sender })
    return true
  }

  func windowDidBecomeKey(_: Notification) {
    (
      NSApp?.orderedWindows
        .first(where: { $0.windowController is WindowController })?
        .windowController as? WindowController
    )?
      .focusSearchField(nil)
  }
}
