import XCTest
@testable import SBFoundation

final class MeasurementProtocolTests: XCTestCase {
    
    private struct Runway: Decodable {
        
        struct Response: Codable {
            
            let length_ft: Double
            
            let displaced_threshold_ft: Double?
        }
        
        enum CodingKeys: String, CodingKey {
            case length = "length_ft"
            case displacedThreshold = "displaced_threshold_ft"
        }
        
        let length: Length
        
        let displacedThreshold: Length?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            length = try container.decode(forKey: .length, unit: .feet)
            displacedThreshold = try container.decodeIfPresent(forKey: .displacedThreshold, unit: .feet)
        }
    }
    
    func test() throws {
        let encodedData = try JSONEncoder().encode(Runway.Response(length_ft: 10000, displaced_threshold_ft: nil))
        let runway = try JSONDecoder().decode(Runway.self, from: encodedData)
        XCTAssertEqual(runway.length, Length(10000, .feet))
        XCTAssertNil(runway.displacedThreshold)
    }
}
