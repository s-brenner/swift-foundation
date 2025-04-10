import XCTest
@testable import SBFoundation

final class MeasurementTests: XCTestCase {
    
    func testSpeeds() {
        XCTAssertEqual(Speed(1, .feetPerSecond).converted(to: .metersPerSecond).value, 0.3048)
        XCTAssertEqual(Speed(1, .feetPerSecond).converted(to: .feetPerMinute).value, 60)
    }
    
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
