import Foundation

enum CustomError: Error, CustomDebugStringConvertible {
    case message(String)
    
    var debugDescription: String {
        switch self {
        case .message(let string): return string
        }
    }
}
