import SBFoundationMacrosPlugin
import MacroTesting
import XCTest

final class TimeZoneMacroTests: BaseTestCase {
    
    override func invokeTest() {
        withMacroTesting(
            macros: ["TimeZone": TimeZoneMacro.self]
        ) {
            super.invokeTest()
        }
    }
    
    func testValidIdentifier() throws {
        assertMacro {
        """
        #TimeZone(identifier: "America/Denver")
        """
        } expansion: {
        """
        TimeZone(identifier: "America/Denver")!
        """
        }
    }
    
    func testInvalidIdentifier() throws {
        assertMacro {
        """
        #TimeZone(identifier: "America/Altus")
        """
        } diagnostics: {
        """
        #TimeZone(identifier: "America/Altus")
        ┬─────────────────────────────────────
        ╰─ 🛑 Invalid identifier: "America/Altus"
        """
        }
    }
}
