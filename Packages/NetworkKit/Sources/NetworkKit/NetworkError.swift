import Foundation

/// Errors that can occur during networking
public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .invalidResponse:
            return "The server response was invalid"
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
