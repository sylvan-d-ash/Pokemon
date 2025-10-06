import Foundation
import NetworkKit

enum PokemonEndpoint: Endpoint {
    case list(offset: Int, limit: Int)
    case info(id: Int)

    var method: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var body: Data? { nil }

    var path: String {
        switch self {
        case .list: "/pokemon"
        case .info(let id): "/pokemon/\(id)"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let offset, let limit):
            return [
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)"),
            ]
        case .info: return nil
        }
    }
}
