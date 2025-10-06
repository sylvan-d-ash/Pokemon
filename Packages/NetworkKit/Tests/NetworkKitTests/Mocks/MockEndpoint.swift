import Foundation
@testable import NetworkKit

struct MockEndpoint: Endpoint {
    var path: String
    var method: HTTPMethod
    var headers: [String : String]?
    var queryItems: [URLQueryItem]?
    var body: Data?

    init(
        path: String,
        queryItems: [URLQueryItem]? = nil,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) {
        self.path = path
        self.queryItems = queryItems
        self.method = method
        self.headers = headers
        self.body = body
    }
}
