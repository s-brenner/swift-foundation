extension Int {
    
    ///- Author: Scott Brenner | SBFoundation
    public func callAsFunction<Unit>(_ unit: Unit) -> Measurement<Unit> {
        Measurement(value: Double(self), unit: unit)
    }
}
