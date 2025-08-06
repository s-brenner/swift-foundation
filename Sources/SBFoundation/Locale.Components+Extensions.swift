#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Locale.Components {
    
    /// - Author: Scott Brenner | SBFoundation
    public func variant(_ variant: Locale.Variant?) -> Self {
        var output = self
        output.variant = variant
        return output
    }
}
#endif
