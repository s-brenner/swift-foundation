import XCTest
@testable import SBFoundation

final class URLSessionExtensionsTests: XCTestCase {
    
    let urls = [
        #URL(string: "https://raw.githubusercontent.com/s-brenner/performance/main/aircraft_2024_1.json"),
        #URL(string: "https://raw.githubusercontent.com/s-brenner/performance/main/non_normal_configuration_2024_1.json"),
    ]
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func testDownload() async throws {
        var progress: URLSession.CumulativeDownloadProgress?
        for try await status in URLSession.shared.download(from: urls) {
            switch status {
            case .cumulativeProgress(let cumulativeProgress):
                progress = cumulativeProgress
            case .downloadProgress(let downloadProgress):
//                if let url = downloadProgress.request.url {
//                    print("Download Progress: \(downloadProgress.fractionCompleted.formatted(.percent)) | \(url.lastPathComponent)")
//                }
                if let previousFractionCompleted = progress?.fractionCompleted,
                   let fractionCompleted = progress?.update(child: downloadProgress) {
                    XCTAssertEqual(fractionCompleted, previousFractionCompleted + 0.01, accuracy: 0.0001)
//                    print("Cumulative Progress: \(fractionCompleted.formatted(.percent))")
                }
            case .finished(let request, let url):
                if let data = try? Data(contentsOf: url),
                   let url = request.url {
                    XCTAssertEqual(progress?.child(for: request)?.totalBytesExpectedToWrite, data.count)
                    print("Finished: \(data.description) | \(url.lastPathComponent)")
                }
            }
        }
    }
    
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func testData() async throws {
        var progress: URLSession.CumulativeDownloadProgress?
        for try await status in URLSession.shared.data(from: urls) {
            switch status {
            case .cumulativeProgress(let cumulativeProgress):
                progress = cumulativeProgress
            case .downloadProgress(let downloadProgress):
//                if let url = downloadProgress.request.url {
//                    print("Download Progress: \(downloadProgress.fractionCompleted.formatted(.percent)) | \(url.lastPathComponent)")
//                }
                if let previousFractionCompleted = progress?.fractionCompleted,
                   let fractionCompleted = progress?.update(child: downloadProgress) {
                    XCTAssertEqual(fractionCompleted, previousFractionCompleted + 0.01, accuracy: 0.0001)
//                    print("Cumulative Progress: \(fractionCompleted.formatted(.percent))")
                }
            case .finished(let request, let data):
                if let url = request.url {
                    XCTAssertEqual(progress?.child(for: request)?.totalBytesExpectedToWrite, data.count)
                    print("Finished: \(data.description) | \(url.lastPathComponent)")
                }
            }
        }
    }
}
