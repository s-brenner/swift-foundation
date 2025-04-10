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
    
    func testCalDav() async throws {
        let body = """
        <d:propfind xmlns:d="DAV:" xmlns:cs="https://ual-calendar.etriptrader.com">
          <d:prop>
             <d:displayname />
          </d:prop>
        </d:propfind>
        """
        
        let body2 = """
        <d:propfind xmlns:d="DAV:" xmlns:cs="http://calendarserver.org/ns/" xmlns:cal="urn:ietf:params:xml:ns:caldav">
          <d:prop>
            <d:current-user-privilege-set/>
            <d:resourcetype />
            <d:displayname />
            <cs:source/>
            <cal:supported-calendar-component-set/>
          </d:prop>
        """
        
        let body3 = """
        <c:calendar-query xmlns:c="urn:ietf:params:xml:ns:caldav" xmlns:d="DAV:">
          <d:prop>
            <d:getetag/>
          </d:prop>
         <c:filter>
           <c:comp-filter name="VCALENDAR">
             <c:comp-filter name="VEVENT">
             </c:comp-filter>
           </c:comp-filter>
         </c:filter>
        </c:calendar-query>
        """
        
        let request = URLRequest.Builder()
            .withScheme(.https)
            .withHost("ual-calendar.etriptrader.com")
            .withPath("caldav.php/373815/")
            .withMethod(.propfind)
            .withHeader(.authorization(.basic(username: "373815", password: "gUhryf-4dyxfa-kognyb")))
            .withBody(body2.data(using: .utf8))
            .build()
        
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse
        else { return }
        print(response.statusCode)
        guard let string = String(data: data, encoding: .utf8)
        else { return }
        print(string)
    }
}
