//
//  NetworkService.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

protocol APIEndpoint {
    var path: String { get }
    var parameters: [String: Any]? { get }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .decodingFailed: return "Decoding failed"
        }
    }
}

protocol NetworkService {
    func fetch<T: Decodable>(_ type: T.Type, endpoint: APIEndpoint) async -> Result<T, Error>
}

final class URLSessionNetworkService: NetworkService {
    private let baseURLString = "https://pokeapi.co/api/v2"

    func fetch<T>(_ type: T.Type, endpoint: any APIEndpoint) async -> Result<T, Error> where T : Decodable {
        guard var url = URL(string: baseURLString) else {
            return .failure(NetworkError.invalidURL)
        }
        url = url.appending(path: endpoint.path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return .failure(NetworkError.invalidURL)
        }
        components.queryItems = getQueryItems(for: endpoint)

        guard let url = components.url else {
            return .failure(NetworkError.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkError.invalidResponse)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(NetworkError.invalidResponse)
            }

            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedResponse)
        } catch _ as DecodingError {
            return .failure(NetworkError.decodingFailed)
        } catch {
            #if DEBUG
            print("[Network] Error: \(error.localizedDescription)")
            #endif

            return .failure(error)
        }
    }

    private func getQueryItems(for endpoint: APIEndpoint) -> [URLQueryItem]? {
        let parameters = endpoint.parameters ?? [:]

        return parameters.map { key, value in
            var stringValue: String?

            switch value {
            case let string as String:
                stringValue = string
            case let number as NSNumber:
                stringValue = number.stringValue
            default:
                // Skip unsupported types
                break
            }

            return URLQueryItem(name: key, value: stringValue)
        }
    }
}
