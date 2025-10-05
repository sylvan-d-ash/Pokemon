import Testing
@testable import NetworkKit

@Suite("HTTPMethod Tests")
struct HTTPMethodTests {
    @Test("HTTPMethod raw values are correct", arguments: [
        (HTTPMethod.get, "GET"),
        (HTTPMethod.post, "POST"),
        (HTTPMethod.put, "PUT"),
        (HTTPMethod.delete, "DELETE"),
        (HTTPMethod.patch, "PATCH")
    ])
    func httpMethodRawValues(method: HTTPMethod, expectedRawValue: String) {
        #expect(method.rawValue == expectedRawValue)
    }
}
