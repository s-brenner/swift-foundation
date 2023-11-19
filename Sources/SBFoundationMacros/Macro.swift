import Foundation

/// Check if provided identifier is a valid time zone identifier and produce a non-optional TimeZone value. Emit error otherwise.
@freestanding(expression)
public macro timeZone(identifier: String) -> TimeZone = #externalMacro(module: "TimeZoneMacroMacros", type: "TimeZoneMacro")
