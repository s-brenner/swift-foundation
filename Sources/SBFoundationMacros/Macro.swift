import Foundation

/// Check if provided identifier is a valid time zone identifier and produce a non-optional TimeZone value. Emit error otherwise.
@freestanding(expression)
public macro TimeZone(identifier: String) -> TimeZone = #externalMacro(module: "SBFoundationMacrosPlugin", type: "TimeZoneMacro")

/// Check if provided string is a valid time url string and produce a non-optional URL value. Emit error otherwise.
@freestanding(expression)
public macro URL(string: String) -> URL = #externalMacro(module: "SBFoundationMacrosPlugin", type: "URLMacro")

/// Check if provided string is a valid uuid string and produce a non-optional UUID value. Emit error otherwise.
@freestanding(expression)
public macro UUID(uuidString: String) -> UUID = #externalMacro(module: "SBFoundationMacrosPlugin", type: "UUIDMacro")
