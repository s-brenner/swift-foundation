/// Returns the `y` value for the given `x` value along the line between points `(x1, y1)` and `(x2, y2)`.
///- Author: Scott Brenner | SBFoundation
///- Parameter x: The given `x` value. Must be between `x1` and `x2` or between `x2` and `x1`.
///- Parameter x1: The `x` value for the first point.
///- Parameter y2: The `y` value for the first point.
///- Parameter x2: The `x` value for the second point.
///- Parameter y2: The `y` value for the second point.
///- Returns: The `y` value for the given `x` value along the line between the two points or `nil` if the given `x` value is not along the line between the two points.
public func interpolate<U1, U2>(
    x: Measurement<U1>,
    x1: Measurement<U1>,
    y1: Measurement<U2>,
    x2: Measurement<U1>,
    y2: Measurement<U2>
) -> Measurement<U2>?
where U1: Dimension, U2: Dimension {
    guard let value = interpolate(
        x: x.value,
        x1: x1.converted(to: x.unit).value,
        y1: y1.value,
        x2: x2.converted(to: x.unit).value,
        y2: y2.converted(to: y1.unit).value
    )
    else { return nil }
    return Measurement(value, y1.unit)
}
