import Testing
import Foundation
@testable import NetworkKit

@Suite("Endpoint Tests")
struct EndpointTests {
    @Test("Endpoint initializes with default values")
    func endpointDefaultValues() {
        // When
        let endpoint = MockEndpoint(path: "/test")

        // Then
        #expect(endpoint.path == "/test")
        #expect(endpoint.queryItems == nil)
        #expect(endpoint.method == .get)
        #expect(endpoint.headers == nil)
        #expect(endpoint.body == nil)
    }

    @Test("Endpoint initializes with custom values")
    func endpointCustomValues() {
        // Given
        let queryItems = [URLQueryItem(name: "key", value: "value")]
        let headers = ["Authorization": "Bearer token"]
        let body = "test".data(using: .utf8)

        // When
        let endpoint = MockEndpoint(
            path: "/custom",
            queryItems: queryItems,
            method: .post,
            headers: headers,
            body: body
        )

        // Then
        #expect(endpoint.path == "/custom")
        #expect(endpoint.queryItems?.count == 1)
        #expect(endpoint.method == .post)
        #expect(endpoint.headers?["Authorization"] == "Bearer token")
        #expect(endpoint.body == body)
    }
}
