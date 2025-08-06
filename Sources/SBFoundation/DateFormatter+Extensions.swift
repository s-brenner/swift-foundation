#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension DateFormatter {
    
    /// - Author: Scott Brenner | SBFoundation
    public static func shared(locale: Locale, timeZone: TimeZone, dateFormat: String) -> DateFormatter {
        let name = """
            SBFoundation.\(String(describing: DateFormatter.self))\
            .locale=\(locale.identifier)\
            .timeZone=\(timeZone.identifier)\
            .dateFormat=\(dateFormat)
        """
        let formatter: DateFormatter = threadSharedObject(key: name) {
            configure(DateFormatter()) {
                $0.locale = locale
                $0.timeZone = timeZone
                $0.dateFormat = dateFormat
            }
        }
        return formatter
    }
}
#endif
