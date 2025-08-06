#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension HTTPURLResponse {
    
    private enum HTTPDate: String, CaseIterable {
        /// RFC 1123
        case rfc1123 = "EEE, dd MMM yyyy HH:mm:ss z"
        /// RFC 850
        case rfc850 = "EEEE, dd-MMM-yy HH:mm:ss z"
        /// ANSI C's asctime() format
        case asctime = "EEE MMM d HH:mm:ss yyyy"
        
        var dateFormatter: DateFormatter {
            let locale = if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
                Locale(components: Locale.Components(languageCode: .english, languageRegion: .unitedStates).variant(.posix))
            } else {
                Locale(identifier: "en_US_POSIX")
            }
            return .shared(locale: locale, timeZone: .gmt, dateFormat: rawValue)
        }
    }
    
    public var date: Date? {
        value(forHTTPHeaderField: "Date")
            .flatMap { value in
                HTTPDate.allCases.lazy
                    .compactMap { $0.dateFormatter.date(from: value) }
                    .first
            }
    }
}
#endif
