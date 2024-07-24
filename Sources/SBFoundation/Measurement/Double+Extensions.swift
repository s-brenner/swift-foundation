extension Double {
    
    ///- Author: Scott Brenner | SBFoundation
    public func callAsFunction<Unit>(_ unit: Unit) -> Measurement<Unit> {
        Measurement(value: self, unit: unit)
    }
}
