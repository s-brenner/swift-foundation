#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension Measurement {
    
    ///- Author: Scott Brenner | SBFoundation
    public var abs: Self { Measurement(value: Swift.abs(value), unit: unit) }
    
    ///- Author: Scott Brenner | SBFoundation
    public func rounded(
        places: Int = 0,
        rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero
    ) -> Self {
        .init(value: value.roundedTo(places: places, rule: rule), unit: unit)
    }
}

extension Measurement
where UnitType: Dimension {
    
    ///- Author: Scott Brenner | SBFoundation
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public struct CustomFormatStyle: Foundation.FormatStyle {
                
        let style: Measurement.FormatStyle
        
        ///- Author: Scott Brenner | SBFoundation
        public static func measurement(
            width: Measurement<UnitType>.FormatStyle.UnitWidth,
            usage: MeasurementFormatUnitUsage<UnitType> = .general,
            numberFormatStyle: FloatingPointFormatStyle<Double>? = nil
        ) -> Self {
            self.init(style: .measurement(width: width, usage: usage, numberFormatStyle: numberFormatStyle))
        }
        
        ///- Author: Scott Brenner | SBFoundation
        public func format(_ value: Measurement<UnitType>) -> String {
            value.formatted(style)
        }
    }
    
    ///- Author: Scott Brenner | SBFoundation
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func formatted(_ customStyle: CustomFormatStyle) -> String {
        customStyle.format(self)
    }
    
    ///- Author: Scott Brenner | SBFoundation
    public static var zero: Self { Self(0, UnitType.baseUnit()) }
    
    ///- Author: Scott Brenner | SBFoundation
    public func isAlmostEqual(to rhs: Measurement<UnitType>, tolerance: Double = 0.00001) -> Bool {
        Swift.abs(rhs.converted(to: unit).value - value) <= tolerance
    }
    
    ///- Author: Scott Brenner | SBFoundation
    public static func /(lhs: Self, rhs: Self) -> Double {
        lhs.converted(to: .baseUnit()).value / rhs.converted(to: .baseUnit()).value
    }
    
    ///- Author: Scott Brenner | SBFoundation
    public subscript(unit: UnitType) -> Self {
        get { converted(to: unit) }
        set { self = newValue }
    }
    
    /// Returns the `y` value for the value of `self` along the line between points `p0` and `p1`.
    ///- Author: Scott Brenner | SBFoundation
    ///- Parameter p0: The first point.
    ///- Parameter p1: The second point.
    ///- Returns: The `y` value for the value of `self` along the line between the two points or `nil` if the value of `self` is not along the line between the two points.
    ///- Note: A `nil` return value indicates that either both points share a common `x` value or extrapolation is necessary.
    public func interpolate<OtherUnitType>(
        between p0: (x: Measurement<UnitType>, y: Measurement<OtherUnitType>),
        and p1: (x: Measurement<UnitType>, y: Measurement<OtherUnitType>)
    ) -> Measurement<OtherUnitType>?
    where OtherUnitType: Dimension {
        guard let newValue = value.interpolate(
            between: (p0.x.converted(to: unit).value, p0.y.value),
            and: (p1.x.converted(to: unit).value, p1.y.converted(to: p0.y.unit).value)
        )
        else { return nil }
        return Measurement<OtherUnitType>(newValue, p0.y.unit)
    }
    
    /// Returns the `y` value for the value of `self` along the line extended from points `p0` and `p1`.
    ///- Author: Scott Brenner | SBFoundation
    ///- Parameter p0: The first point.
    ///- Parameter p1: The second point.
    ///- Returns: The `y` value for the value of `self` along the line extended from the two points or `nil` if the value of `self` is along the line between the two points.
    ///- Note: A `nil` return value indicates that either both points share a common `x` value or interpolation is necessary.
    public func extrapolate<OtherUnitType>(
        from p0: (x: Measurement<UnitType>, y: Measurement<OtherUnitType>),
        and p1: (x: Measurement<UnitType>, y: Measurement<OtherUnitType>)
    ) -> Measurement<OtherUnitType>?
    where OtherUnitType: Dimension {
        guard let newValue = value.extrapolate(
            from: (p0.x.converted(to: unit).value, p0.y.value),
            and: (p1.x.converted(to: unit).value, p1.y.converted(to: p0.y.unit).value)
        )
        else { return nil }
        return Measurement<OtherUnitType>(newValue, p0.y.unit)
    }
}

///- Author: Scott Brenner | SBFoundation
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension Measurement.CustomFormatStyle
where UnitType == UnitTemperature {
    
    ///- Author: Scott Brenner | SBFoundation
    public static func measurement(
        width: Measurement<UnitType>.FormatStyle.UnitWidth,
        usage: MeasurementFormatUnitUsage<UnitType> = .general,
        hidesScaleName: Bool = false,
        numberFormatStyle: FloatingPointFormatStyle<Double>? = nil
    ) -> Self {
        self.init(style: .measurement(width: width, usage: usage, hidesScaleName: hidesScaleName, numberFormatStyle: numberFormatStyle))
    }
}

///- Author: Scott Brenner | SBFoundation
public func sin(_ angle: Angle) -> Double { sin(angle.converted(to: .radians).value) }

///- Author: Scott Brenner | SBFoundation
public func cos(_ angle: Angle) -> Double { cos(angle.converted(to: .radians).value) }

///- Author: Scott Brenner | SBFoundation
public func tan(_ angle: Angle) -> Double { tan(angle.converted(to: .radians).value) }

///- Author: Scott Brenner | SBFoundation
public typealias Acceleration = Measurement<UnitAcceleration>

///- Author: Scott Brenner | SBFoundation
public typealias Angle = Measurement<UnitAngle>

///- Author: Scott Brenner | SBFoundation
public typealias Area = Measurement<UnitArea>

///- Author: Scott Brenner | SBFoundation
public typealias ConcentrationMass = Measurement<UnitConcentrationMass>

///- Author: Scott Brenner | SBFoundation
public typealias Dispersion = Measurement<UnitDispersion>

///- Author: Scott Brenner | SBFoundation
public typealias Duration = Measurement<UnitDuration>

///- Author: Scott Brenner | SBFoundation
public typealias ElectricCharge = Measurement<UnitElectricCharge>

///- Author: Scott Brenner | SBFoundation
public typealias ElectricCurrent = Measurement<UnitElectricCurrent>

///- Author: Scott Brenner | SBFoundation
public typealias ElectricPotentialDifference = Measurement<UnitElectricPotentialDifference>

///- Author: Scott Brenner | SBFoundation
public typealias ElectricResistance = Measurement<UnitElectricResistance>

///- Author: Scott Brenner | SBFoundation
public typealias Energy = Measurement<UnitEnergy>

///- Author: Scott Brenner | SBFoundation
public typealias Frequency = Measurement<UnitFrequency>

///- Author: Scott Brenner | SBFoundation
public typealias FuelEfficiency = Measurement<UnitFuelEfficiency>

///- Author: Scott Brenner | SBFoundation
public typealias Illuminance = Measurement<UnitIlluminance>

///- Author: Scott Brenner | SBFoundation
public typealias Length = Measurement<UnitLength>

///- Author: Scott Brenner | SBFoundation
public typealias Mass = Measurement<UnitMass>

///- Author: Scott Brenner | SBFoundation
public typealias Power = Measurement<UnitPower>

///- Author: Scott Brenner | SBFoundation
public typealias Pressure = Measurement<UnitPressure>

///- Author: Scott Brenner | SBFoundation
public typealias Speed = Measurement<UnitSpeed>

///- Author: Scott Brenner | SBFoundation
public typealias Temperature = Measurement<UnitTemperature>

///- Author: Scott Brenner | SBFoundation
public typealias Volume = Measurement<UnitVolume>
#endif

#if canImport(SwiftUI)
import SwiftUI

extension SwiftUI.Angle {
    
    ///- Author: Scott Brenner | SBFoundation
    public init(_ angle: Angle) {
        self.init(degrees: angle.converted(to: .degrees).value)
    }
}

extension Angle {
    
    ///- Author: Scott Brenner | SBFoundation
    public init(_ angle: SwiftUI.Angle) {
        self.init(angle.degrees, .degrees)
    }
}
#endif
