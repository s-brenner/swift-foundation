#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension URLSession {
    
    public struct DownloadProgress: Codable, Hashable, Sendable {
        
        public let totalBytesWritten: Int
        
        public let totalBytesExpectedToWrite: Int
        
        public let fractionCompleted: Double
        
        public init(totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
            self.totalBytesWritten = totalBytesWritten
            self.totalBytesExpectedToWrite = totalBytesExpectedToWrite
            fractionCompleted = (totalBytesWritten.double / totalBytesExpectedToWrite.double).roundedTo(places: 2, rule: .toNearestOrAwayFromZero)
        }
        
        public init(children progress: DownloadProgress...) {
            self.init(
                totalBytesWritten: progress.map(\.totalBytesWritten).reduce(0, +),
                totalBytesExpectedToWrite: progress.map(\.totalBytesExpectedToWrite).reduce(0, +)
            )
        }
        
        public static func zero(totalBytesExpectedToWrite: Int) -> Self {
            Self(totalBytesWritten: 0, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        }
    }
    
    public enum DownloadStatus<Output> {
        case downloading(DownloadProgress)
        case finished(Output)
    }
    
    public typealias AsyncDownloadStatus<T> = AsyncThrowingStream<DownloadStatus<T>, Error>
    
    public func dataStatus(from url: URL) async throws -> (response: URLResponse, status: AsyncDownloadStatus<Data>) {
        let request = URLRequest(url: url)
        return try await dataStatus(for: request)
    }
    
    public func dataStatus(for request: URLRequest) async throws -> (response: URLResponse, status: AsyncDownloadStatus<Data>) {
        let (bytes, response) = try await self.bytes(for: request)
        let status = AsyncDownloadStatus<Data> { continuation in
            Task {
                do {
                    let length = Int(response.expectedContentLength)
                    var data = Data()
                    if length.isPositive {
                        data.reserveCapacity(length)
                    }
                    var progress: Double = 0
                    continuation.yield(.downloading(.zero(totalBytesExpectedToWrite: length)))
                    for try await byte in bytes {
                        data.append(byte)
                        guard length.isPositive
                        else { continue }
                        let currentProgress = (data.count.double / length.double)
                            .roundedTo(places: 2, rule: .toNearestOrAwayFromZero)
                        if progress != currentProgress {
                            progress = currentProgress
                            continuation.yield(.downloading(DownloadProgress(totalBytesWritten: data.count, totalBytesExpectedToWrite: length)))
                        }
                    }
                    if progress != 1 {
                        continuation.yield(.downloading(DownloadProgress(totalBytesWritten: data.count, totalBytesExpectedToWrite: length)))
                    }
                    continuation.yield(.finished(data))
                    continuation.finish()
                }
                catch {
                    continuation.finish(throwing: error)
                }
            }
        }
        return (response, status)
    }
}

extension URLResponse {
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public var initialDownloadStatus: URLSession.DownloadProgress {
        .zero(totalBytesExpectedToWrite: Int(expectedContentLength))
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension URLSession.DownloadStatus {
    
    public func map<T>(_ transform: (Output) throws -> T) rethrows -> URLSession.DownloadStatus<T> {
        switch self {
        case .downloading(let progress): return .downloading(progress)
        case .finished(let output): return .finished(try transform(output))
        }
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension URLSession.DownloadStatus where Output == Data {
    
    public func decode<T>(
        _ type: T.Type = T.self,
        using decoder: JSONDecoder = JSONDecoder()
    ) throws -> URLSession.DownloadStatus<T>
    where T: Decodable {
        try map { try decoder.decode(type, from: $0) }
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension URLSession.DownloadStatus where Output: Collection {
    
    public func mapEach<T>(_ transform: (Output.Element) throws -> T) rethrows -> URLSession.DownloadStatus<[T]> {
        try map { try $0.map(transform) }
    }
}
#endif
