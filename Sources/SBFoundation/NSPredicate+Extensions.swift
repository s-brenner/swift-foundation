#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension NSPredicate {
    
    ///- Author: Scott Brenner | SBFoundation
    public static func or(_ subpredicates: [NSPredicate]) -> NSPredicate {
        NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
    }
    
    ///- Author: Scott Brenner | SBFoundation
    public static func and(_ subpredicates: [NSPredicate]) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
    }
    
    ///- Author: Scott Brenner | SBFoundation
    public var data: Data {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
        else { return Data() }
        return data
    }
    
    ///- Author: Scott Brenner | SBFoundation
    public static func from(_ data: Data) throws -> NSPredicate? {
        try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPredicate.self, from: data)
    }
}
#endif
