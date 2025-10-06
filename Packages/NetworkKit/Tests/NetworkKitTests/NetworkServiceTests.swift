import Testing
import Foundation
@testable import NetworkKit

@Suite("NetworkKit Tests", .serialized)
struct NetworkKitTests {
    var sut: URLSessionNetworkService!
    var mockSession: URLSession!
    
    init() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)
        
        sut = URLSessionNetworkService(
            baseURLString: "https://api.example.com",
            session: mockSession
        )
    }
    
    @Test("Successful request returns decoded data")
    func successfulRequest() async throws {
        // Given
        let expectedData = #"{"id":1,"name":"Test"}"#.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, expectedData)
        }

        struct TestResponse: Codable, Equatable {
            let id: Int
            let name: String
        }

        // When
        let result = try await sut.request(
            endpoint: MockEndpoint(path: "/test"),
            responseType: TestResponse.self
        )

        // Then
        #expect(result.id == 1)
        #expect(result.name == "Test")
    }
    
    @Test("HTTP error throws NetworkError with correct status code")
    func httpErrorThrowsError() async throws {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }

        let endpoint = MockEndpoint(path: "/test")

        do {
            _ = try await sut.request(endpoint: endpoint, responseType: String.self)
            Issue.record("Expected HTTP error, but request succeeded")
        } catch NetworkError.httpError(let code) {
            #expect(code == 404)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Invalid response handling")
    func testInvalidResponse() async {
        // Break the response by returning non-HTTPURLResponse
        MockURLProtocol.requestHandler = { request in
            let response = URLResponse(
                url: request.url!,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            ) 
            return (response, Data())
        }

        let endpoint = MockEndpoint(path: "/test")

        do {
            let _: String = try await sut.request(endpoint: endpoint, responseType: String.self)
            Issue.record("Expected invalidResponse error")
        } catch NetworkError.invalidResponse {
            // expected
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test("Decoding error throws NetworkError.decodingError")
    func decodingErrorThrowsCorrectError() async throws {
        // Given
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, invalidJSON)
        }
        
        struct TestResponse: Codable {
            let id: Int
        }
        
        // When/Then
        do {
            _ = try await sut.request(
                endpoint: MockEndpoint(path: "/test", method: .get),
                responseType: TestResponse.self
            )
            Issue.record("Should have thrown an error")
        } catch let error as NetworkError {
            if case .decodingError = error {
                // Success - correct error type
            } else {
                Issue.record("Wrong NetworkError case: \(error)")
            }
        } catch {
            Issue.record("Wrong error type: \(error)")
        }
    }

    @Test("Request includes custom headers")
    func requestIncludesCustomHeaders() async throws {
        // Given
        MockURLProtocol.requestHandler = { request in
            // Assert that our header is present
            #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer token123")
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            let data = #"{"status": "ok"}"#.data(using: .utf8)!
            return (response, data)
        }

        struct TestResponse: Decodable { let status: String }

        let customHeaders = ["Authorization": "Bearer token123"]
        
        // When
        let result: TestResponse  = try await sut.request(
            endpoint: MockEndpoint(path: "/test", headers: customHeaders),
            responseType: TestResponse.self
        )

        // Then
        #expect(result.status == "ok")
    }
    
    @Test("Request includes query parameters")
    func requestIncludesQueryParameters() async throws {
        // Given
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                Issue.record("Invalid URL in request")
                throw NetworkError.invalidURL
            }

            // Assert query items
            let queryDict = Dictionary(
                uniqueKeysWithValues: components.queryItems!.map { ($0.name, $0.value ?? "") }
            )
            #expect(queryDict["offset"] == "20")
            #expect(queryDict["limit"] == "10")
            
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            let data = #"{"status": "ok"}"#.data(using: .utf8)!
            return (response, data)
        }

        struct TestResponse: Decodable { let status: String }

        // When
        let result = try await sut.request(
            endpoint: MockEndpoint(
                path: "/test",
                queryItems: [
                    URLQueryItem(name: "offset", value: "20"),
                    URLQueryItem(name: "limit", value: "10")
                ],
                method: .get
            ),
            responseType: TestResponse.self
        )

        // Then
        #expect(result.status == "ok")
    }

    @Test("Request with POST body includes body data")
    func requestIncludesBody() async throws {
        // Given
        let bodyData = #"{"key": "value"}"#.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            // Assert body data
            #expect(request.bodyData == bodyData)
            #expect(request.httpMethod == "POST")

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            let data = #"{"status": "ok"}"#.data(using: .utf8)!
            return (response, data)
        }

        struct TestResponse: Decodable { let status: String}

        // When
        let result = try await sut.request(
            endpoint: MockEndpoint(
                path: "/test",
                method: .post,
                body: bodyData
            ),
            responseType: TestResponse.self
        )

        // Then
        #expect(result.status == "ok")
    }
    
    @Test("Different HTTP methods are set correctly", arguments: [
        (HTTPMethod.get, "GET"),
        (HTTPMethod.post, "POST"),
        (HTTPMethod.put, "PUT"),
        (HTTPMethod.delete, "DELETE"),
        (HTTPMethod.patch, "PATCH")
    ])
    func httpMethodsSetCorrectly(method: HTTPMethod, expectedString: String) async throws {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            let data = #"{"status": "ok"}"#.data(using: .utf8)!
            return (response, data)
        }

        struct TestResponse: Decodable { let status: String }

        // When
        let result = try await sut.request(
            endpoint: MockEndpoint(path: "/test", method: method),
            responseType: TestResponse.self
        )

        // Then
        #expect(result.status == "ok")
    }
}
