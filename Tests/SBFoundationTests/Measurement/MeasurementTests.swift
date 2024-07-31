import XCTest
@testable import SBFoundation

final class MeasurementTests: XCTestCase {
    
    func testInterpolate() {
        XCTAssertEqual(
            Speed(5, .knots).interpolate(between: (0(.knots), 0(.feet)), and: (10(.knots), 10(.inches))),
            Length(5, .inches)
        )
    }
}
