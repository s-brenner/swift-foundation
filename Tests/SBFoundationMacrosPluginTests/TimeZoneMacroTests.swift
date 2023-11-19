import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(TimeZoneMacroMacros)
import TimeZoneMacroMacros

let testMacros: [String: Macro.Type] = [
    "timeZone": TimeZoneMacro.self,
//    "stringify": StringifyMacro.self,
]
#endif

final class TimeZoneMacroTests: XCTestCase {
    
    func testMacro() throws {
        #if canImport(TimeZoneMacroMacros)
        assertMacroExpansion(
            """
            #timeZone(identifier: "America/Denver")
            """,
            expandedSource: """
            TimeZone(identifier: "America/Denver")!
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

//    func testMacroWithStringLiteral() throws {
//        #if canImport(TimeZoneMacroMacros)
//        assertMacroExpansion(
//            #"""
//            #stringify("Hello, \(name)")
//            """#,
//            expandedSource: #"""
//            ("Hello, \(name)", #""Hello, \(name)""#)
//            """#,
//            macros: testMacros
//        )
//        #else
//        throw XCTSkip("macros are only supported when running tests for the host platform")
//        #endif
//    }
}
