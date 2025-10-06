import Testing
import Foundation
@testable import NetworkKit

@Suite("NetworkError Tests")
struct NetworkErrorTests {
    
    @Test("NetworkError provides correct error descriptions")
    func errorDescriptions() {
        let testCases: [(NetworkError, String)] = [
            (.invalidURL, "The URL is invalid"),
            (.invalidResponse, "The server response was invalid"),
            (.httpError(statusCode: 404), "HTTP error with status code: 404"),
        ]
        
        for (error, expectedDescription) in testCases {
            #expect(error.errorDescription?.contains(expectedDescription) == true)
        }
    }
    
    @Test("NetworkError httpError includes status code")
    func httpErrorIncludesStatusCode() {
        let error = NetworkError.httpError(statusCode: 500)
        #expect(error.errorDescription?.contains("500") == true)
    }
    
    @Test("NetworkError decodingError includes underlying error")
    func decodingErrorIncludesUnderlyingError() {
        struct DummyError: Error, LocalizedError {
            var errorDescription: String? { "Dummy error" }
        }
        
        let underlyingError = DummyError()
        let error = NetworkError.decodingError(underlyingError)
        
        #expect(error.errorDescription?.contains("decode") == true)
        #expect(error.errorDescription?.contains("Dummy error") == true)
    }
}