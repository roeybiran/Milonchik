import XCTest

@testable import Milonchik

class ListViewControllerTests: XCTestCase {
  // var sut: ListViewController!
  //
  // override func setUpWithError() throws {
  //     try super.setUpWithError()
  //     sut = ListViewController(onSelect: { (_) in })
  // }
  //
  // override func tearDownWithError() throws {
  //     try super.tearDownWithError()
  //     sut = nil
  // }
  //
  // func test_tableViewDelegateAndDataSource_shouldBeConnected() {
  //     XCTAssertNotNil(sut.tableView.dataSource, "data source")
  //     XCTAssertNotNil(sut.tableView.delegate, "delegate")
  // }
  //
  // func test_numberOfRows_shouldBe3() {
  //     sut.updateListItems(with: [1, 2, 3].map({ _ in GroupRow() }))
  //     XCTAssertEqual(numberOfRows(in: sut.tableView), 3)
  // }
  //
  // func test_viewForRow_shouldBeNSTableCellViewWithGroupRowIdentifier() {
  //     sut.updateListItems(with: [1, 2, 3].map({ _ in GroupRow() }))
  //
  //     guard
  //         let cellView = (sut.tableView.delegate?.tableView?(sut.tableView, viewFor: nil, row: 0)) as? NSTableCellView
  //     else {
  //         XCTFail("expected NSTableCellView, got unknown")
  //         return
  //     }
  //
  //     XCTAssertEqual(cellView.identifier, .groupRowCell, "cell identifier")
  //     XCTAssertEqual(cellView.textField?.stringValue, "Suggestions", "text field value")
  // }
  //
  // func test_selectionDidChange_shouldTriggerOnSelect() {
  //     let mockDefinitions = [1, 2, 3].map { num in
  //         Definition(id: num, translatedWord: "", translatedWordSanitized: "", translations: [], partOfSpeech: nil,
  //                    synonyms: [], samples: [], inflections: [], translatedLanguage: .eng)
  //     }
  //     let _expectation = expectation(description: "expectation")
  //     var shouldFulfill = false
  //     let _sut = ListViewController(onSelect: { _ in
  //         // to avoid excessive calls to `fulfill()`
  //         if shouldFulfill {
  //             _expectation.fulfill()
  //         }
  //     })
  //     _sut.updateListItems(with: mockDefinitions)
  //     shouldFulfill = true
  //     _sut.tableView.delegate?.tableViewSelectionDidChange?(Notification(name: NSTableView.selectionDidChangeNotification))
  //     waitForExpectations(timeout: 0.1)
  // }
}
