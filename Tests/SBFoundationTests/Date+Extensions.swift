import XCTest
@testable import SBFoundation

final class DateExtensionsTests: XCTestCase {
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func testCapitalizationContext() {
        var context: Date.RelativeFormatStyle = .relative(presentation: .named)
        XCTAssertEqual(context.capitalizationContext, .unknown)
        context = context.capitalizationContext(.beginningOfSentence)
        XCTAssertEqual(context.capitalizationContext, .beginningOfSentence)
    }
}
