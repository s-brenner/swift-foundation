import XCTest
@testable import SBFoundation

final class ClosedRangeExtensionsTests: XCTestCase {
    
    func testIn() {
        let range = Length(12, .inches)...Length(24, .inches)
        XCTAssertEqual(range.in(.feet).roundedTo(places: 10), 1...2)
    }
}
