#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
///- Author: Scott Brenner | SBFoundation
@propertyWrapper
public struct Clamping<Value> where Value: Comparable {
    
    var value: Value
    
    let range: ClosedRange<Value>
    
    public var wrappedValue: Value {
        get { value }
        set { value = newValue.clamped(to: range) }
    }
    
    public init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        value = wrappedValue.clamped(to: range)
        self.range = range
    }
}
#endif
