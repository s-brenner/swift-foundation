import XCTest
@testable import SBFoundation

final class UnitProductTests: XCTestCase {
    
    func test() {
        XCTAssertEqual(Duration(1, .hours) * Speed(1, .milesPerHour), Length(1, .miles))
        XCTAssertEqual(Speed(1, .milesPerHour) * Duration(1, .hours), Length(1, .miles))
        XCTAssertEqual(Length(1, .miles) / Duration(1, .hours), Speed(1, .milesPerHour))
        
        XCTAssertEqual(Length(1, .meters) * Area(1, .squareMeters), Volume(1, .cubicMeters))
        XCTAssertEqual(Area(1, .squareMeters) * Length(1, .meters), Volume(1, .cubicMeters))
        XCTAssertEqual(Volume(1, .cubicMeters) / Length(1, .meters), Area(1, .squareMeters))
        XCTAssertEqual(Volume(1, .cubicMeters) / Area(1, .squareMeters), Length(1, .meters))
    }
}
