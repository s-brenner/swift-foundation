import XCTest
@testable import SBFoundation

final class ClampingTests: XCTestCase {
    
    private struct Solution {
        @Clamping(0...14) var ph = 7.0
    }
    
    func test() {
        let carbonicAcid = Solution(ph: 4.68)
        let superDuperAcid = Solution(ph: -1)
        XCTAssertEqual(carbonicAcid.ph, 4.68)
        XCTAssertEqual(superDuperAcid.ph, 0)
    }
}
