#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension Date {
    
    ///- Author: Scott Brenner | SBFoundation
    public static func dates(spanning interval: DateInterval) -> [Date] {
        dates(from: interval.start, to: interval.end)
    }
    
    ///- Author: Scott Brenner | SBFoundation
    public static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
            else { break }
            date = newDate
        }
        return dates
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension Date.RelativeFormatStyle {
    
    ///- Author: Scott Brenner | SBFoundation
    public func capitalizationContext(_ capitalizationContext: FormatStyleCapitalizationContext) -> Self {
        var style = self
        style.capitalizationContext = capitalizationContext
        return style
    }
}
#endif
