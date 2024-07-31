import XCTest
@testable import SBFoundation

final class MeasurementTests: XCTestCase {
    
    func testInterpolate() {
        XCTAssertEqual(
            Speed(5, .knots).interpolate(between: (0(.knots), 0(.feet)), and: (10(.knots), 10(.inches))),
            Length(5, .inches)
        )
        XCTAssertNil(Speed(11, .knots).interpolate(between: (0(.knots), Length(0, .feet)), and: (10(.knots), 10(.inches))))
    }
    
    func testExtrapolate() {
        XCTAssertNil(Speed(5, .knots).extrapolate(from: (0(.knots), Length(0, .feet)), and: (10(.knots), 10(.inches))))
        XCTAssertEqual(
            Speed(11, .knots).extrapolate(from: (0(.knots), 0(.feet)), and: (10(.knots), 10(.inches))),
            Length(11, .inches)
        )
    }
}
