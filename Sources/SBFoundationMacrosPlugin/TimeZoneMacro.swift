import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Creates a non-optional TimeZone from a static string identifier. The identifier is checked to be valid during compile time.
public enum TimeZoneMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression,
              let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
              segments.count == 1,
              case .stringSegment(let literalSegment)? = segments.first
        else {
            throw CustomError.message("#TimeZone requires a static string literal")
        }
        guard let _ = TimeZone(identifier: literalSegment.content.text) else {
            throw CustomError.message("invalid identifier: \(argument)")
        }
        return "TimeZone(identifier: \(argument))!"
    }
}
