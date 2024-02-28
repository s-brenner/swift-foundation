import XCTest
@testable import SBFoundation

final class SpellOutNumberFormatStyleTests: XCTestCase {
    
    func testFormat() {
        XCTAssertEqual(1.formatted(.spellOut), "one")
        XCTAssertEqual(0.1.formatted(.spellOut), "zero point one")
        XCTAssertEqual(1_000_000.formatted(.spellOut), "one million")
    }
}
