import XCTest
@testable import SBFoundation

final class URLRequestTests: XCTestCase {
    
    func testBuilder() {
        let request = URLRequest.Builder()
            .withCachePolicy(.reloadIgnoringLocalAndRemoteCacheData)
            .withTimeoutInterval(45)
            .withScheme(.http)
            .withHost("127.0.0.1")
            .withPort(8080)
            .withPath("v1/users/login")
            .withMethod(.get)
            .withHeader(.accept([.application(.json)]))
            .withHeader(.authorization(.basic(username: "test", password: "secret")))
            .withJSONBody("test")
            .build()
        XCTAssertEqual(request.url!.absoluteString, "http://127.0.0.1:8080/v1/users/login")
        XCTAssertEqual(request.cachePolicy, .reloadIgnoringLocalAndRemoteCacheData)
        XCTAssertEqual(request.timeoutInterval, 45)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: .accept), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: .authorization), "Basic dGVzdDpzZWNyZXQ=")
        XCTAssertEqual(request.httpBody, try! JSONEncoder().encode("test"))
    }
}
