@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension PersonNameComponents.FormatStyle {
    
    ///- Author: Scott Brenner | SBFoundation
    public func locale(_ locale: Locale) -> Self {
        var style = self
        style.locale = locale
        return style
    }
    
    ///- Author: Scott Brenner | SBFoundation
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public func locale(languageCode: Locale.LanguageCode, languageRegion: Locale.Region) -> Self {
        locale(Locale(languageCode: languageCode, languageRegion: languageRegion))
    }
}
