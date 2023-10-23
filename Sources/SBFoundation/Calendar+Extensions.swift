#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension Calendar {
    
    public static let buddhist = Calendar(identifier: .buddhist)
    
    public static let chinese = Calendar(identifier: .chinese)
    
    public static let coptic = Calendar(identifier: .coptic)
    
    public static let ethiopicAmeteAlem = Calendar(identifier: .ethiopicAmeteAlem)
    
    public static let ethiopicAmeteMihret = Calendar(identifier: .ethiopicAmeteMihret)
    
    public static let gregorian = Calendar(identifier: .gregorian)
    
    public static let hebrew = Calendar(identifier: .hebrew)
    
    public static let indian = Calendar(identifier: .indian)
    
    public static let islamic = Calendar(identifier: .islamic)
    
    public static let islamicCivil = Calendar(identifier: .islamicCivil)
    
    public static let islamicTabular = Calendar(identifier: .islamicTabular)
    
    public static let islamicUmmAlQura = Calendar(identifier: .islamicUmmAlQura)
    
    public static let iso8601 = Calendar(identifier: .iso8601)
    
    public static let japanese = Calendar(identifier: .japanese)
    
    public static let persian = Calendar(identifier: .persian)
}

extension Calendar {
    
    static let staticCalendars = Calendar.Identifier.allCases
        .map { "public static let \($0.description) = Calendar(identifier: .\($0.description))" }
}

extension Calendar.Identifier: CaseIterable {
    
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

extension Calendar.Identifier: CustomStringConvertible {
    
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
