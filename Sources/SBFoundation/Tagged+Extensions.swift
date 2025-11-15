#if canImport(Tagged) && (os(macOS) || os(iOS) || os(watchOS) || os(tvOS))
import Tagged

public protocol InspectableTagProtocol {
    associatedtype Root
}

public enum IDTag<Root>: InspectableTagProtocol {
    public typealias Value = (Root, id: ())
}

public typealias TaggedID<Root, RawValue> = Tagged<IDTag<Root>.Value, RawValue>

public typealias TaggedUUID<Root> = TaggedID<Root, UUID>
#endif
