import XCTest

@testable import Milonchik

class WindowManagerTests: XCTestCase {

    // var sut: WindowManager!
    // 
    // override func setUpWithError() throws {
    //     sut = WindowManager()
    // }
    // 
    // override func tearDownWithError() throws {
    //     sut = nil
    // }
    // 
    // func test_delegateOfManagedWindow_shouldExist() {
    //     sut.makeNewWindow(tabbed: false)
    //     XCTAssertNotNil(sut.managedWindowControllers.first?.window?.delegate, "window delegate")
    // }

    // func test_windowManagerAsNSWindowDelegate_shouldMakeSearchFieldFirstResponder() {
    //     sut.makeNewWindow(tabbed: false)
    //     let controller = sut.managedWindowControllers.first
    //     XCTAssertEqual(true, controller?.window?.firstResponder !== controller?.searchField)
    //     NSWindow().addChildWindow(controller!.window!, ordered: .above)
    //     controller?.window?.delegate?.windowDidBecomeKey?(Notification(name: NSWindow.didBecomeKeyNotification))
    //     RunLoop.current.run(until: Date())
    //     XCTAssertEqual(true, controller?.window?.firstResponder === controller?.searchField)
    // }

}
