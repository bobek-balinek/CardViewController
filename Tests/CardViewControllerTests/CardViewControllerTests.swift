import XCTest
@testable import CardViewController

final class CardViewControllerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CardViewController().titleLabel.text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
