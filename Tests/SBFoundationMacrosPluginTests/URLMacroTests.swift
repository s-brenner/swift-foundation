import SBFoundationMacrosPlugin
import MacroTesting
import XCTest

final class URLMacroTests: BaseTestCase {
    
    override func invokeTest() {
        withMacroTesting(
            macros: ["URL": URLMacro.self]
        ) {
            super.invokeTest()
        }
    }
    
    func testValidURL() throws {
        assertMacro {
        """
        #URL(string: "www.google.com")
        """
        } expansion: {
        """
        URL(string: "www.google.com")!
        """
        }
    }
}
