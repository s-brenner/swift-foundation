extension OutputStream {

    public enum OutputStreamError: Error {
        case bufferFailure
        case writeFailure
    }

    public func write(_ data: Data) throws {
        try data.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) throws in
            guard var pointer = buffer.baseAddress?.assumingMemoryBound(to: UInt8.self)
            else { throw OutputStreamError.bufferFailure }
            var bytesRemaining = buffer.count
            while bytesRemaining > 0 {
                let bytesWritten = write(pointer, maxLength: bytesRemaining)
                if bytesWritten < 0 {
                    throw OutputStreamError.writeFailure
                }
                bytesRemaining -= bytesWritten
                pointer += bytesWritten
            }
        }
    }
}
