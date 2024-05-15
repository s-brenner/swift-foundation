import Foundation

extension ClosedRange {
    
    ///- Author: Scott Brenner | SBFoundation
    public func `in`<UnitType>(_ unit: UnitType) -> ClosedRange<Double>
    where Bound == Measurement<UnitType>, UnitType: Dimension {
        let lower = lowerBound.converted(to: unit).value
        let upper = upperBound.converted(to: unit).value
        return lower...upper
    }
    
    ///- Author: Scott Brenner | SBFoundation
    public func roundedTo(places: Int = 0, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self
    where Bound: BinaryFloatingPoint {
        let lower = lowerBound.roundedTo(places: places, rule: rule)
        let upper = upperBound.roundedTo(places: places, rule: rule)
        return lower...upper
    }
}
