#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension Calendar {
    
    ///- Author: Scott Brenner | SBFoundation
    public static let buddhist = Calendar(identifier: .buddhist)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let chinese = Calendar(identifier: .chinese)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let coptic = Calendar(identifier: .coptic)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let ethiopicAmeteAlem = Calendar(identifier: .ethiopicAmeteAlem)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let ethiopicAmeteMihret = Calendar(identifier: .ethiopicAmeteMihret)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let gregorian = Calendar(identifier: .gregorian)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let hebrew = Calendar(identifier: .hebrew)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let indian = Calendar(identifier: .indian)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let islamic = Calendar(identifier: .islamic)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let islamicCivil = Calendar(identifier: .islamicCivil)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let islamicTabular = Calendar(identifier: .islamicTabular)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let islamicUmmAlQura = Calendar(identifier: .islamicUmmAlQura)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let iso8601 = Calendar(identifier: .iso8601)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let japanese = Calendar(identifier: .japanese)
    
    ///- Author: Scott Brenner | SBFoundation
    public static let persian = Calendar(identifier: .persian)
    
    ///- Author: Scott Brenner | SBFoundation
    public func date(containing date: Date, in timeZone: TimeZone, transform: (inout DateComponents) -> Void) -> Date? {
        var components = dateComponents(in: timeZone, from: date)
        transform(&components)
        return self.date(from: components)
    }
    
    ///- Author: Scott Brenner | SBFoundation
    public func startOfDay(containing date: Date, in timeZone: TimeZone) -> Date {
        self.date(containing: date, in: timeZone) {
            $0.hour = 0
            $0.minute = 0
            $0.second = 0
            $0.nanosecond = 0
        }!
    }
    
    ///- Author: Scott Brenner | SBFoundation
    public func endOfDay(containing date: Date, in timeZone: TimeZone) -> Date {
        var calendar = self
        calendar.timeZone = timeZone
        let nextDay = calendar.date(byAdding: .day, value: 1, to: date)!
        return calendar.date(byAdding: .second, value: -1, to: startOfDay(containing: nextDay, in: timeZone))!
    }
}

extension Calendar {
    
    static let staticCalendars = Calendar.Identifier.allCases
        .map { "public static let \($0.description) = Calendar(identifier: .\($0.description))" }
}

extension Calendar.Identifier: @retroactive CaseIterable {
    
    public static let allCases: [Calendar.Identifier] = [
        .buddhist,
        .chinese,
        .coptic,
        .ethiopicAmeteAlem,
        .ethiopicAmeteMihret,
        .gregorian,
        .hebrew,
        .indian,
        .islamic,
        .islamicCivil,
        .islamicTabular,
        .islamicUmmAlQura,
        .iso8601,
        .japanese,
        .persian,
        .republicOfChina,
    ]
}

extension Calendar.Identifier: @retroactive CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .buddhist: return "buddhist"
        case .chinese: return "chinese"
        case .coptic: return "coptic"
        case .ethiopicAmeteAlem: return "ethiopicAmeteAlem"
        case .ethiopicAmeteMihret: return "ethiopicAmeteMihret"
        case .gregorian: return "gregorian"
        case .hebrew: return "hebrew"
        case .indian: return "indian"
        case .islamic: return "islamic"
        case .islamicCivil: return "islamicCivil"
        case .islamicTabular: return "islamicTabular"
        case .islamicUmmAlQura: return "islamicUmmAlQura"
        case .iso8601: return "iso8601"
        case .japanese: return "japanese"
        case .persian: return "persian"
        case .republicOfChina: return "republicOfChina"
        @unknown default: return "unknown"
        }
    }
}
#endif
