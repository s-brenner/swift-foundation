import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Creates a non-optional UUID from a static string. The string is checked to be valid during compile time.
public enum UUIDMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.arguments.first?.expression,
              let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
              segments.count == 1,
              case .stringSegment(let literalSegment)? = segments.first
        else {
            throw CustomError.message("#UUID requires a static string literal")
        }
        guard let _ = UUID(uuidString: literalSegment.content.text) else {
            throw CustomError.message("Invalid uuidString: \(argument)")
        }
        return "UUID(uuidString: \(argument))!"
    }
}
