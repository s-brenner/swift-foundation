import XCTest
@testable import SBFoundation

final class SpellOutNumberFormatStyleTests: XCTestCase {
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func testFormat() {
        XCTAssertEqual(1.formatted(.spellOut), "one")
        XCTAssertEqual(0.1.formatted(.spellOut), "zero point one")
        XCTAssertEqual(1_000_000.formatted(.spellOut), "one million")
    }
}
