import SBFoundationMacrosPlugin
import MacroTesting
import XCTest

final class UUIDMacroTests: BaseTestCase {
    
    override func invokeTest() {
        withMacroTesting(
            macros: ["UUID": UUIDMacro.self]
        ) {
            super.invokeTest()
        }
    }
    
    func testValidIdentifier() throws {
        assertMacro {
        """
        #UUID(uuidString: "b10b0000-dead-beef-dead-beefdeadbeef")
        """
        } expansion: {
        """
        UUID(uuidString: "b10b0000-dead-beef-dead-beefdeadbeef")!
        """
        }
    }
    
    func testInvalidIdentifier() throws {
        assertMacro {
        """
        #UUID(uuidString: ""bl0b0000-dead-beef-dead-beefdeadbeef"")
        """
        } diagnostics: {
        #"""
        #UUID(uuidString: ""bl0b0000-dead-beef-dead-beefdeadbeef"")
                            ┬─────────────────────────────────────
        │                   ╰─ 🛑 unexpected code 'bl0b0000-dead-beef-dead-beefdeadbeef""' in macro expansion
        ┬──────────────────────────────────────────────────────────
        ╰─ 🛑 message("invalid uuidString: \"\"")
        """#
        }
    }
}
