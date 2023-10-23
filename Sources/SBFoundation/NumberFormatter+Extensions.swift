#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension NumberFormatter {
    
    /// Returns a string containing the formatted value of the provided integer.
    /// - Author: Scott Brenner | SBFoundation
    /// - Parameter integer: An `Int` object that is parsed to create the returned string object.
    /// - Returns: A string containing the formatted value of the integer using the receiver’s current settings.
    public func string(from integer: Int) -> String? {
        string(from: NSNumber(integerLiteral: integer))
    }
}
#endif
