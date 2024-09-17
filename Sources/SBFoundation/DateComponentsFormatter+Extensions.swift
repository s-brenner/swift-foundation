#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension DateComponentsFormatter {
    
    /// Configures formatter to return a value like "1d 0h 12m"
    ///- Author: Scott Brenner | SBFoundation
    public static let dayHourMinute = configure(DateComponentsFormatter()) {
        $0.allowedUnits = [.day, .hour, .minute]
        $0.unitsStyle = .abbreviated
        $0.zeroFormattingBehavior = .pad
    }
}
#endif
