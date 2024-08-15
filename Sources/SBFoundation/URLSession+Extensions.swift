#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension URLSession {
    
    /// - Author: Scott Brenner | SBFoundation
    public typealias AsyncFileDownloadStatus = AsyncThrowingStream<DownloadStatus<URL>, Error>
    
    /// - Author: Scott Brenner | SBFoundation
    public typealias AsyncDataDownloadStatus = AsyncThrowingStream<DownloadStatus<Data>, Error>
    
    /// - Author: Scott Brenner | SBFoundation
    public enum DownloadStatus<Output>: Sendable
    where Output: Sendable {
        case downloadProgress(DownloadProgress)
        case cumulativeProgress(CumulativeDownloadProgress)
        case finished(URLRequest, Output)
        
//        public func map<T>(_ transform: (Output) throws -> T) rethrows -> URLSession.DownloadStatus<T> {
//            switch self {
//            case .downloadProgress(let progress): return .downloadProgress(progress)
//            case .cumulativeProgress(let progress): return .cumulativeProgress(progress)
//            case .finished(let request, let output): return .finished(request, try transform(output))
//            }
//        }
    }
    
    /// Download progress associated with a specific download request.
    /// - Author: Scott Brenner | SBFoundation
    public struct DownloadProgress: Hashable, Sendable {
        
        public let request: URLRequest
        
        public let totalBytesWritten: Int
        
        public let totalBytesExpectedToWrite: Int
        
        public let fractionCompleted: Double
        
        public init?(request: URLRequest, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
            guard totalBytesExpectedToWrite != -1
            else { return nil }
            self.request = request
            self.totalBytesWritten = totalBytesWritten
            self.totalBytesExpectedToWrite = totalBytesExpectedToWrite
            fractionCompleted = (totalBytesWritten.double / totalBytesExpectedToWrite.double).roundedTo(places: 2, rule: .toNearestOrAwayFromZero)
        }
    }
    
    /// Cumulative progress associated with an array of download requests.
    /// - Author: Scott Brenner | SBFoundation
    public struct CumulativeDownloadProgress: Hashable, Sendable {
        
        private var children: [URLRequest: DownloadProgress]
        
        public private(set) var fractionCompleted: Double = 0
        
        init(for children: [DownloadProgress]) {
            var dictionary = [URLRequest: DownloadProgress]()
            children.forEach {
                dictionary[$0.request] = $0
            }
            self.children = dictionary
        }
        
        public var totalBytesWritten: Int {
            children.map(\.value.totalBytesWritten).reduce(0, +)
        }
        
        public var totalBytesExpectedToWrite: Int {
            children.map(\.value.totalBytesExpectedToWrite).reduce(0, +)
        }
        
        public func child(for request: URLRequest) -> DownloadProgress? {
            children[request]
        }
        
        /// Updates the child progress and returns the download fraction completed if it is at least 0.01 higher than the previously reported download fraction completed.
        /// - Parameter progress: The child progress to update.
        /// - Returns: The download fraction completed if it is at least 0.01 higher than the previously reported download fraction completed.
        @discardableResult
        mutating public func update(child progress: DownloadProgress) -> Double? {
            children[progress.request] = progress
            let currentFractionCompleted = (totalBytesWritten.double / totalBytesExpectedToWrite.double)
                .roundedTo(places: 2, rule: .toNearestOrAwayFromZero)
            guard currentFractionCompleted > fractionCompleted
            else { return nil }
            fractionCompleted = currentFractionCompleted
            return fractionCompleted
        }
    }
    
    /// Retrieves the contents of an array of URLs and delivers an asynchronous sequence of download statuses.
    /// - Parameter urls: An array of URLs.
    /// - Parameter delegate: A delegate that receives life cycle and authentication challenge callbacks as the transfer progresses.
    /// - Returns: An asynchronous sequence of download statuses that includes the requested data.
    /// - Author: Scott Brenner | SBFoundation
    public func data(from urls: [URL], delegate: (any URLSessionTaskDelegate)? = nil) -> AsyncDataDownloadStatus {
        let requests = urls.map { URLRequest(url: $0) }
        return data(for: requests)
    }
    
    /// Retrieves the contents of an array of URLs based on the specified URL requests and delivers an asynchronous sequence of download statuses.
    /// - Parameter requests: An array of URL request objects that provide request-specific information such as the URL, cache policy, request type, and body data or body stream.
    /// - Parameter delegate: A delegate that receives life cycle and authentication challenge callbacks as the transfer progresses.
    /// - Returns: An asynchronous sequence of download statuses that includes the requested data.
    /// - Author: Scott Brenner | SBFoundation
    public func data(for requests: [URLRequest], delegate: (any URLSessionTaskDelegate)? = nil) -> AsyncDataDownloadStatus {
        AsyncDataDownloadStatus { continuation in
            let task = Task {
                do {
                    let downloads = try await requests.asyncMap {
                        let (asyncBytes, urlResponse) = try await self.bytes(for: $0, delegate: delegate)
                        let progress = DownloadProgress(request: $0, totalBytesWritten: 0, totalBytesExpectedToWrite: Int(urlResponse.expectedContentLength))
                        return (request: $0, asyncBytes: asyncBytes, progress: progress)
                    }
                    let children = downloads.compactMap(\.progress)
                    continuation.yield(.cumulativeProgress(CumulativeDownloadProgress(for: children)))
                    children.forEach {
                        continuation.yield(.downloadProgress($0))
                    }
                    await withTaskGroup(of: Void.self) { group in
                        for (request, asyncBytes, progress) in downloads {
                            group.addTask { [weak self] in
                                do {
                                    try await self?.process(
                                        request: request,
                                        asyncBytes: asyncBytes,
                                        totalBytesExpectedToWrite: progress?.totalBytesExpectedToWrite ?? 0,
                                        onReportDownloadProgress: { continuation.yield(.downloadProgress($0)) },
                                        onReportFinished: { continuation.yield(.finished(request, $0)) }
                                    )
                                }
                                catch {
                                    continuation.finish(throwing: error)
                                }
                            }
                        }
                    }
                    continuation.finish()
                }
                catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
    
    /// Retrieves the contents of an array of URLs and delivers an asynchronous sequence of download statuses.
    /// - Parameter urls: An array of URLs.
    /// - Parameter delegate: A delegate that receives life cycle and authentication challenge callbacks as the transfer progresses.
    /// - Returns: An asynchronous sequence of download statuses that includes the URLs of the saved files asynchronously.
    /// - Author: Scott Brenner | SBFoundation
    public func download(from urls: [URL], delegate: (any URLSessionTaskDelegate)? = nil) -> AsyncFileDownloadStatus {
        let requests = urls.map { URLRequest(url: $0) }
        return download(for: requests)
    }
    
    /// Retrieves the contents of an array of URLs based on the specified URL requests and delivers an asynchronous sequence of download statuses.
    /// - Parameter requests: An array of URL request objects that provide request-specific information such as the URL, cache policy, request type, and body data or body stream.
    /// - Parameter delegate: A delegate that receives life cycle and authentication challenge callbacks as the transfer progresses.
    /// - Returns: An asynchronous sequence of download statuses that includes the URLs of the saved files asynchronously.
    /// - Author: Scott Brenner | SBFoundation
    public func download(for requests: [URLRequest], delegate: (any URLSessionTaskDelegate)? = nil) -> AsyncFileDownloadStatus {
        AsyncFileDownloadStatus { continuation in
            let task = Task {
                do {
                    let downloads = try await requests.asyncMap {
                        let (asyncBytes, urlResponse) = try await self.bytes(for: $0, delegate: delegate)
                        let progress = DownloadProgress(request: $0, totalBytesWritten: 0, totalBytesExpectedToWrite: Int(urlResponse.expectedContentLength))
                        return (request: $0, asyncBytes: asyncBytes, progress: progress)
                    }
                    let children = downloads.compactMap(\.progress)
                    continuation.yield(.cumulativeProgress(CumulativeDownloadProgress(for: children)))
                    children.forEach {
                        continuation.yield(.downloadProgress($0))
                    }
                    await withTaskGroup(of: Void.self) { group in
                        for (request, asyncBytes, progress) in downloads {
                            group.addTask { [weak self] in
                                do {
                                    try await self?.process(
                                        request: request,
                                        asyncBytes: asyncBytes,
                                        totalBytesExpectedToWrite: progress?.totalBytesExpectedToWrite ?? 0,
                                        onReportDownloadProgress: { continuation.yield(.downloadProgress($0)) },
                                        onReportFinished: { continuation.yield(.finished(request, $0)) }
                                    )
                                }
                                catch {
                                    continuation.finish(throwing: error)
                                }
                            }
                        }
                    }
                    continuation.finish()
                }
                catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
    
    private func process(
        request: URLRequest,
        asyncBytes: AsyncBytes,
        totalBytesExpectedToWrite: Int,
        onReportDownloadProgress reportDownloadProgress: (DownloadProgress) -> Void,
        onReportFinished reportFinished: (Data) -> Void
    ) async throws {
        let expectedLength = max(totalBytesExpectedToWrite, 0)
        var data = Data()
        if expectedLength.isPositive {
            data.reserveCapacity(expectedLength)
        }
        var progress: Double = 0
        for try await byte in asyncBytes {
            try Task.checkCancellation()
            data.append(byte)
            guard expectedLength.isPositive
            else { continue }
            let currentProgress = (data.count.double / expectedLength.double)
                .roundedTo(places: 2, rule: .toNearestOrAwayFromZero)
            if progress != currentProgress {
                progress = currentProgress
                if let downloadProgress = DownloadProgress(request: request, totalBytesWritten: data.count, totalBytesExpectedToWrite: expectedLength) {
                    reportDownloadProgress(downloadProgress)
                }
            }
        }
        if let downloadProgress = DownloadProgress(request: request, totalBytesWritten: data.count, totalBytesExpectedToWrite: data.count) {
            reportDownloadProgress(downloadProgress)
        }
        reportFinished(data)
    }
    
    private func process(
        request: URLRequest,
        asyncBytes: AsyncBytes,
        totalBytesExpectedToWrite: Int,
        onReportDownloadProgress reportDownloadProgress: (DownloadProgress) -> Void,
        onReportFinished reportFinished: (URL) -> Void
    ) async throws {
        let bufferSize = 65_536
        let expectedLength = max(totalBytesExpectedToWrite, 0)
        let fileURL = URL.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        guard let output = OutputStream(url: fileURL, append: false)
        else { throw URLError(.cannotOpenFile) }
        output.open()
        var buffer = Data()
        if expectedLength > 0 {
            buffer.reserveCapacity(min(bufferSize, Int(expectedLength)))
        }
        else {
            buffer.reserveCapacity(bufferSize)
        }
        var progress: Double = 0
        var count = 0
        for try await byte in asyncBytes {
            try Task.checkCancellation()
            count += 1
            buffer.append(byte)
            if buffer.count >= bufferSize {
                try output.write(buffer)
                buffer.removeAll(keepingCapacity: true)
            }
            guard expectedLength.isPositive
            else { continue }
            let currentProgress = (count.double / expectedLength.double)
                .roundedTo(places: 2, rule: .toNearestOrAwayFromZero)
            if progress != currentProgress {
                progress = currentProgress
                if let downloadProgress = DownloadProgress(request: request, totalBytesWritten: count, totalBytesExpectedToWrite: expectedLength) {
                    reportDownloadProgress(downloadProgress)
                }
            }
        }
        if !buffer.isEmpty {
            try output.write(buffer)
        }
        output.close()
        if let downloadProgress = DownloadProgress(request: request, totalBytesWritten: count, totalBytesExpectedToWrite: count) {
            reportDownloadProgress(downloadProgress)
        }
        reportFinished(fileURL)
    }
}

//@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
//extension URLSession.DownloadStatus where Output == Data {
//    
//    public func decode<T>(
//        _ type: T.Type = T.self,
//        using decoder: JSONDecoder = JSONDecoder()
//    ) throws -> URLSession.DownloadStatus<T>
//    where T: Decodable {
//        try map { try decoder.decode(type, from: $0) }
//    }
//}
//
//@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
//extension URLSession.DownloadStatus where Output: Collection {
//    
//    public func mapEach<T>(_ transform: (Output.Element) throws -> T) rethrows -> URLSession.DownloadStatus<[T]> {
//        try map { try $0.map(transform) }
//    }
//}
#endif
