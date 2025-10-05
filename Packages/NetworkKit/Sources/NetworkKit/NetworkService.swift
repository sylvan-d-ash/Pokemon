import Foundation

/// Generic network service protocol
public protocol NetworkService: Sendable {
    /// Performs a network request and returns decoded data
    /// - Parameters:
    ///   - endpoint: The endpoint to request
    ///   - type: The type to decode the response into
    /// - Returns: Decoded response of the specified type
    func request<T: Decodable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T
}

/// Supported HTTP methods
public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// Represents an API endpoint
public protocol Endpoint: Sendable {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}
