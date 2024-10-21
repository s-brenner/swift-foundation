#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
///- Author: Scott Brenner | SBFoundation
public protocol MeasurementProtocol {
    
    associatedtype UnitType
    
    ///- Author: Scott Brenner | SBFoundation
    init(_ value: Double, _ unit: UnitType)
    
    ///- Author: Scott Brenner | SBFoundation
    @_disfavoredOverload
    init?(_ value: Double?, _ unit: UnitType)
}

extension Measurement: MeasurementProtocol {
    
    public init(_ value: Double, _ unit: UnitType) {
        self.init(value: value, unit: unit)
    }
    
    public init?(_ value: Double?, _ unit: UnitType) {
        guard let value
        else { return nil }
        self.init(value: value, unit: unit)
    }
}

extension UnkeyedDecodingContainer {
    
    /// Decodes a value of the given type.
    /// - Parameter type: The type of value to decode.
    /// - Parameter unit: The unit of measure.
    /// - Returns: A value of the requested type, if present and convertible to `Double`.
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to `Double`.
    /// - Throws: `DecodingError.valueNotFound` if the encountered encoded value is null, or if there are no more values to decode.
    ///- Author: Scott Brenner | SBFoundation
    public mutating func decode<M>(_ type: M.Type = M.self, unit: M.UnitType) throws -> M
    where M: MeasurementProtocol {
        M(try decode(Double.self), unit)
    }
    
    /// Decodes a value of the given type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to decode, or if the value is null.
    /// The difference between these states can be distinguished by checking `isAtEnd`.
    /// - Parameter type: The type of value to decode.
    /// - Parameter unit: The unit of measure.
    /// - Returns: A decoded value of the requested type, or `nil` if the value is a null value, or if there are no more elements to decode.
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to `Double`.
    ///- Author: Scott Brenner | SBFoundation
    public mutating func decodeIfPresent<M>(_ type: M.Type = M.self, unit: M.UnitType) throws -> M?
    where M: MeasurementProtocol {
        M(try decodeIfPresent(Double.self), unit)
    }
}

extension KeyedDecodingContainer {
    
    /// Decodes a value of the given type for the given key.
    /// - Parameter type: The type of value to decode.
    /// - Parameter key: The key that the decoded value is associated with.
    /// - Parameter unit: The unit of measure.
    /// - Returns: A value of the requested type, if present for the given key and convertible to `Double`.
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to `Double`.
    /// - Throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
    /// - Throws: `DecodingError.valueNotFound` if self has a null entry for the given key.`
    ///- Author: Scott Brenner | SBFoundation
    public func decode<M>(_ type: M.Type = M.self, forKey key: Key, unit: M.UnitType) throws -> M
    where M: MeasurementProtocol {
        M(try decode(Double.self, forKey: key), unit)
    }
    
    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with the key, or if the value is null.
    /// The difference between these states can be distinguished with a `contains(_:)` call.
    /// - Parameter type: The type of value to decode.
    /// - Parameter key: The key that the decoded value is associated with.
    /// - Parameter unit: The unit of measure.
    /// - Returns: A decoded value of the requested type, or nil if the Decoder does not have an entry associated with the given key, or if the value is a null value.
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to `Double`.
    ///- Author: Scott Brenner | SBFoundation
    public func decodeIfPresent<M>(_ type: M.Type = M.self, forKey key: Key, unit: M.UnitType) throws -> M?
    where M: MeasurementProtocol {
        M(try decodeIfPresent(Double.self, forKey: key), unit)
    }
}
#endif
