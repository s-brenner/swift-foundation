#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension URLSession {
    
    public enum DownloadStatus {
        case response(HTTPURLResponse)
        case downloading(Double)
        case finished(Data)
    }
    
    public func downloadStatus(from url: URL) -> AsyncThrowingStream<DownloadStatus, Error> {
        let request = URLRequest(url: url)
        return downloadStatus(for: request)
    }
    
    public func downloadStatus(for request: URLRequest) -> AsyncThrowingStream<DownloadStatus, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let (bytes, response) = try await self.bytes(for: request)
                    let length = Int(response.expectedContentLength)
                    if let response = response as? HTTPURLResponse {
                        continuation.yield(.response(response))
                    }
                    var data = Data()
                    if length.isPositive {
                        data.reserveCapacity(length)
                    }
                    var progress: Double = 0
                    continuation.yield(.downloading(progress))
                    for try await byte in bytes {
                        data.append(byte)
                        guard length.isPositive
                        else { continue }
                        let currentProgress = (data.count.double / length.double)
                            .roundedTo(places: 2, rule: .toNearestOrAwayFromZero)
                        if progress != currentProgress {
                            progress = currentProgress
                            continuation.yield(.downloading(progress))
                        }
                    }
                    if progress != 1 {
                        continuation.yield(.downloading(1))
                    }
                    continuation.yield(.finished(data))
                    continuation.finish()
                }
                catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
#endif
