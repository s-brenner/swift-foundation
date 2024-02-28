import XCTest
@testable import SBFoundation

final class DateExtensionsTests: XCTestCase {
    
    func testCapitalizationContext() {
        var context: Date.RelativeFormatStyle = .relative(presentation: .named)
        XCTAssertEqual(context.capitalizationContext, .unknown)
        context = context.capitalizationContext(.beginningOfSentence)
        XCTAssertEqual(context.capitalizationContext, .beginningOfSentence)
    }
}
