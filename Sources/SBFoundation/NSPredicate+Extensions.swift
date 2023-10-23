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
}
#endif
