import Foundation

/// URLSession-based implementation of NetworkService
public final class URLSessionNetworkService: NetworkService {
    private let baseURLString: String
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(
        baseURLString: String,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURLString = baseURLString
        self.session = session
        self.decoder = decoder
    }

    public func request<T: Decodable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {
        let request = try buildRequest(from: endpoint)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard var url = URL(string: baseURLString) else {
            throw NetworkError.invalidURL
        }
        url = url.appending(path: endpoint.path)

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = endpoint.queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        // Add default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add custom headers
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}