import XCTest
@testable import SBFoundation

final class URLSessionExtensionsTests: XCTestCase {
    
    @available(iOS 15.0, tvOS 15.0, macOS 12.0, watchOS 8.0, *)
    func testDownloadStatus() async {
        let url = URL(string: "https://www.nasa.gov/sites/default/files/thumbnails/image/iss067e005682.jpg")!
        do {
            var expectedContentLength = 0
            var downloadProgress = -0.01
            let (_, statuses) = try await URLSession.shared.dataStatus(from: url)
            for try await status in statuses {
                switch status {
                case .downloading(let progress):
                    XCTAssertEqual(progress.fractionCompleted, downloadProgress + 0.01, accuracy: 0.0001)
                    downloadProgress = progress.fractionCompleted
                    expectedContentLength = progress.totalBytesExpectedToWrite
                case .finished(let data):
                    XCTAssertEqual(data.count, expectedContentLength)
                }
            }
        }
        catch {
            print(error)
            XCTFail("\(error.localizedDescription)")
        }
    }
}
