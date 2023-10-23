#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
/// - Author: Scott Brenner | SBFoundation
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public struct SpellOutNumberFormatStyle<Value>: FormatStyle
where Value: NSNumberConvertible {
    
    public func format(_ value: Value) -> String {
        NumberFormatter.shared(numberStyle: .spellOut).string(from: value.nsNumber)!
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<Decimal> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<Double> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<Float> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<Int8> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<Int32> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<Int> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<Int64> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<Int16> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<UInt8> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<UInt> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<UInt64> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension FormatStyle where Self == SpellOutNumberFormatStyle<UInt16> {
    
    /// - Author: Scott Brenner | SBFoundation
    public static var spellOut: Self { .init() }
}
#endif
