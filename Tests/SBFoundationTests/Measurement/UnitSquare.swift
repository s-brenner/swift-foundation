import XCTest
@testable import SBFoundation

final class UnitSquareTests: XCTestCase {
    
    func test() {
        XCTAssertEqual(Length(1, .meters) * Length(1, .meters), Area(1, .squareMeters))
        XCTAssertEqual(Area(1, .squareMeters) / Length(1, .meters), Length(1, .meters))
    }
}
