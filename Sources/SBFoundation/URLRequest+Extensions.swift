#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
extension URLRequest {
    
    /// - Author: Scott Brenner | SBFoundation
    public enum BodyEncoding {
        case none
        case formData
        case json
        case x_www_form_urlencoded
        
        var header: HTTPHeaderField? {
            switch self {
            case .none: return nil
            case .formData: return .contentType(.multipart(.form_data))
            case .json: return .contentType(.application(.json))
            case .x_www_form_urlencoded: return .contentType(.application(.x_www_form_urlencoded))
            }
        }
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public enum MIMEType: CustomStringConvertible {
        case application(ApplicationSubtype)
        case image(ImageSubtype)
        case multipart(MultipartSubtype)
        case text(TextSubtype)
        
        /// - Author: Scott Brenner | SBFoundation
        public enum ApplicationSubtype: String, MIMESubtype {
            case atom_xml = "atom+xml"
            case ecmascript
            case json
            case javascript
            case octet_stream = "octet-stream"
            case ogg
            case pdf
            case postscript
            case rdf_xml = "rdf+xml"
            case rss_xml = "rss+xml"
            case soap_xml = "soap+xml"
            case font_woff = "font-woff"
            case x_yaml = "x-yaml"
            case xhtml_xml = "xhtml+xml"
            case xml
            case xml_dtd = "xml-dtd"
            case xop_xml = "xop+xml"
            case zip
            case gzip
            case graphql
            case x_www_form_urlencoded = "x-www-form-urlencoded"
        }
        
        /// - Author: Scott Brenner | SBFoundation
        public enum ImageSubtype: String, MIMESubtype {
            case gif, jpeg, pjpeg, png
            case svg_xml = "svg+xml"
            case tiff
        }
        
        /// - Author: Scott Brenner | SBFoundation
        public enum MultipartSubtype: String, MIMESubtype {
            case mixed, alternative, related
            case form_data = "form-data"
            case signed, encrypted
        }
        
        /// - Author: Scott Brenner | SBFoundation
        public enum TextSubtype: String, MIMESubtype {
            case cmd, css, csv, html, plain, vcard, xml
        }
        
        var type: String {
            switch self {
            case .application: return "application"
            case .image: return "image"
            case .multipart: return "multipart"
            case .text: return "text"
            }
        }
        
        public var description: String {
            var subtype: String {
                switch self {
                case .application(let sub): return sub.description
                case .image(let sub): return sub.description
                case .multipart(let sub): return sub.description
                case .text(let sub): return sub.description
                }
            }
            return "\(type)/\(subtype)"
        }
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public enum HTTPHeaderField: CustomStringConvertible {
        case accept([MIMEType])
        case authorization(Authorization)
        case contentType(MIMEType)
        
        /// - Author: Scott Brenner | SBFoundation
        public enum Authorization {
            case basic(username: String, password: String)
            case bearer(credential: String)
            
            var value: String {
                switch self {
                case let .basic(username, password):
                    return "Basic " + "\(username):\(password)".formatted(.base64Encoded())
                case let .bearer(credential):
                    return "Bearer \(credential)"
                }
            }
        }
        
        enum Key: String, CustomStringConvertible {
            case accept = "Accept"
            case authorization = "Authorization"
            case contentType = "Content-Type"
            
            public var description: String { rawValue }
        }
        
        var key: Key {
            switch self {
            case .accept: return .accept
            case .authorization: return .authorization
            case .contentType: return .contentType
            }
        }
        
        var value: String {
            switch self {
            case .accept(let mimes):
                return mimes
                    .map { $0.description }
                    .joined(separator: ",")
            case .authorization(let auth): return auth.value
            case .contentType(let mime): return mime.description
            }
        }
        
        public var description: String { "\(key.description): \(value)" }
    }
    
    mutating func setHTTPHeaderField(to field: HTTPHeaderField) {
        setValue(field.value, forHTTPHeaderField: field.key.description)
    }
    
    func value(forHTTPHeaderField key: HTTPHeaderField.Key) -> String? {
        value(forHTTPHeaderField: key.description)
    }
}

/// - Author: Scott Brenner | SBFoundation
public protocol MIMESubtype: RawRepresentable, CustomStringConvertible {}

public extension MIMESubtype where Self.RawValue == String {
    
    var description: String { rawValue }
}

extension URLRequest {
    
    /// - Author: Scott Brenner | SBFoundation
    public final class Builder {
        
        private(set) var method = HTTPMethod.get
        
        private(set) var scheme = Scheme.https
        
        private(set) var host = ""
        
        private(set) var port: Int?
        
        private(set) var path = ""
        
        private(set) var queryItems = [URLQueryItem]()
        
        private(set) var headers = [URLRequest.HTTPHeaderField]()
        
        private(set) var body: Data?
        
        private(set) var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
        
        private(set) var timeoutInterval: TimeInterval = 60
        
        public init() { }
    }
}

extension URLRequest.Builder {
    
    enum Error: Swift.Error {
        case invalidURL
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public enum HTTPMethod: String, CustomStringConvertible {
        case put
        case post
        case get
        case delete
        case head
        case propfind
        case report
        
        public var description: String { rawValue.uppercased() }
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public enum Scheme: String {
        case http, https
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withMethod(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withScheme(_ scheme: Scheme) -> Self {
        self.scheme = scheme
        return self
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withHost(_ host: String) -> Self {
        self.host = host
        return self
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withPort(_ port: Int) -> Self {
        self.port = port
        return self
    }
    
    /// Returns a builder that includes a path.
    /// - Author: Scott Brenner | SBFoundation
    /// - Parameter path: The path to use.
    /// - Important: Do not include a leading "/" character in the path. It will be added automatically.
    public func withPath(_ path: String) -> Self {
        self.path = path
        return self
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withQueryItem(name: String, value: String?) -> Self {
        queryItems.append(.init(name: name, value: value))
        return self
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withQueryItems(_ items: [URLQueryItem]) -> Self {
        queryItems += items
        return self
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withHeader(_ header: URLRequest.HTTPHeaderField) -> Self {
        headers.append(header)
        return self
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withBody(_ body: Data?, encoding: URLRequest.BodyEncoding = .none) -> Self {
        if let header = encoding.header {
            headers.append(header)
        }
        self.body = body
        return self
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withJSONBody<Value>(_ value: Value, encodedWith encoder: JSONEncoder = .init()) -> Self
    where Value: Encodable {
        self.withBody(try? encoder.encode(value), encoding: .json)
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withCachePolicy(_ cachePolicy: URLRequest.CachePolicy) -> Self {
        self.cachePolicy = cachePolicy
        return self
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func withTimeoutInterval(_ timeoutInterval: TimeInterval) -> Self {
        self.timeoutInterval = timeoutInterval
        return self
    }
    
    /// - Author: Scott Brenner | SBFoundation
    public func build() -> URLRequest {
        switch compose() {
        case .failure(let error):
            fatalError(error.localizedDescription)
        case .success(let request):
            return request
        }
    }
    
    private func compose() -> Result<URLRequest, Error> {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.port = port
        components.path = "/" + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        guard let url = components.url else { return .failure(.invalidURL) }
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = method.description
        headers.forEach { request.setHTTPHeaderField(to: $0) }
        request.httpBody = body
        return .success(request)
    }
}
#endif
