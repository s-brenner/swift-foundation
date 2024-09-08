/// - Author: Scott Brenner | SBFoundation
public final class AcceleratingTimer: NSObject {
    
    private var timer0: Timer?
    
    private var timer1: Timer?
    
    /// Creates a timer and schedules it on the current run loop in the default mode.
    /// - Parameter initialInterval: The initial number of seconds between firings of the timer. If interval is less than or equal to 0.0, this initializer chooses the nonnegative value of 0.0001 seconds instead.
    /// - Parameter calculationInterval: The number of seconds between each recalculation of the time interval between firings of the timer.
    ///   If interval is less than or equal to 0.0, this initializer chooses the nonnegative value of 0.0001 seconds instead.
    /// - Parameter multiplier: The multiplier by which the interval between firings of the timer is multiplied every time it is recalculated. The multiplier is clamped to the range `0.01...0.99`.
    /// - Parameter minimumInterval: The minimum interval between firings of the timer allowed.
    /// - Parameter block: A block to be executed when the timer fires.
    public init(
        initialInterval: TimeInterval,
        calculationInterval: TimeInterval = 0.1,
        multiplier: Double,
        minimumInterval: TimeInterval = 0.0085,
        block: @escaping @Sendable () -> Void
    ) {
        super.init()
        var acceleratingInterval = initialInterval
        let multiplier = max(min(multiplier, 0.99), 0.01)
        timer0 = .scheduledTimer(withTimeInterval: calculationInterval, repeats: true) { [weak self] _ in
            self?.timer1?.invalidate()
            acceleratingInterval = max(acceleratingInterval * multiplier, max(minimumInterval, 0.0085))
            self?.timer1 = .scheduledTimer(withTimeInterval: acceleratingInterval, repeats: true) { _ in
                block()
            }
        }
    }
    
    /// Stops the timer from ever firing again and requests its removal from its run loop.
    ///
    /// ## Special Considerations ##
    /// You must send this message from the thread on which the timer was installed.
    /// If you send this message from another thread, the input source associated with the timer may not be removed from its run loop,
    /// which could prevent the thread from exiting properly.
    public func invalidate() {
        timer0?.invalidate()
        timer1?.invalidate()
    }
    
    /// A Boolean value that indicates whether the timer is currently valid.
    ///
    /// `true` if the receiver is still capable of firing or `false` if the timer has been invalidated and is no longer capable of firing.
    public var isValid: Bool {
        guard let timer0,
              let timer1
        else { return false }
        return timer0.isValid && timer1.isValid
    }
}
