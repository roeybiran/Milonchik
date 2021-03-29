import XCTest

@testable import Milonchik

class WindowManagerTests: XCTestCase {
  var sut: WindowManager!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = WindowManager()
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  func test_windowManager_shouldBeDelegateOfItsWindow() {
    sut.makeNewWindow(tabbed: false)
    XCTAssertTrue(
      sut.managedWindowControllers.first?.window?.delegate === sut,
      "WindowManager is not the delegate of its windows")
  }

  // func test_windowManagerAsNSWindowDelegate_shouldMakeSearchFieldFirstResponder() throws {
  //     sut.makeNewWindow(tabbed: false)
  //     let controller = sut.managedWindowControllers.first
  //     XCTAssertEqual(true, controller?.window?.firstResponder !== controller?.searchField, "precondition")
  //
  //     _ = controller?.contentViewController?.view
  //     controller?.window?.delegate?.windowDidBecomeKey?(Notification(name: NSWindow.didBecomeKeyNotification))
  //     RunLoop.current.run(until: Date())
  //
  //     try XCTSkipIf(controller?.window?.firstResponder !== controller?.searchField)
  //
  // }
}
