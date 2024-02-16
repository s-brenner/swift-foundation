#if canImport(Tagged) && (os(macOS) || os(iOS) || os(watchOS) || os(tvOS))
import Tagged

public typealias TaggedID<T, RawValue> = Tagged<(T, id: ()), RawValue>

public typealias TaggedUUID<T> = TaggedID<T, UUID>
#endif
