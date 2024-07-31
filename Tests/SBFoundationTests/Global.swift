import XCTest
@testable import SBFoundation

final class GlobalTests: XCTestCase {
    
    func testInterpolate() {        
        XCTAssertEqual(interpolate(x: Speed(5, .knots), x1: Speed(0, .knots), y1: Length(0, .feet), x2: Speed(10, .knots), y2: Length(10, .inches)), Length(5, .inches))
    }
}
