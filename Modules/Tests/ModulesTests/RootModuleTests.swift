import XCTest
@testable import SamplesRoot

final class RootTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RootModule().text, "Hello, World!")
    }
}
