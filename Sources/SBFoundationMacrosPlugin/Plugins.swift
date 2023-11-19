import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TimeZoneMacro.self,
        URLMacro.self,
        UUIDMacro.self
    ]
}
