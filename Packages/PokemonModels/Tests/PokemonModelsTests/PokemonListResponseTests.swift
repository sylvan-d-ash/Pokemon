import Foundation
import Testing

@testable import PokemonModels

@Suite("PokemonListResponse Tests")
struct PokemonListResponseTests {
    @Test("PokemonListResponse decodes from JSON")
    func decodesFromJSON() throws {
        let json = """
            {
                "count": 1302,
                "next": "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
                "results": [
                    {
                        "name": "bulbasaur",
                        "id": 1
                    },
                    {
                        "name": "ivysaur",
                        "id": 2
                    }
                ]
            }
            """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let response = try decoder.decode(PokemonListResponse.self, from: json)

        #expect(response.count == 1302)
        #expect(response.next == "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20")
        #expect(response.results.count == 2)
        #expect(response.results.first?.name == "bulbasaur")
    }

    @Test("Decodes valid JSON with empty results")
    func decodesEmptyResults() async throws {
        let json = """
            {
              "count": 0,
              "next": null,
              "results": []
            }
            """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: json)

        #expect(decoded.count == 0)
        #expect(decoded.next == nil)
        #expect(decoded.results.isEmpty)
    }

    @Test("Fails decoding invalid JSON")
    func failsDecodingInvalidJson() async throws {
        let json = """
            {
              "count": "not a number",
              "results": "wrong type"
            }
            """.data(using: .utf8)!

        do {
            _ = try JSONDecoder().decode(PokemonListResponse.self, from: json)
            Issue.record("Decoding should have failed, but succeeded")
        } catch {
            // expected error
        }
    }

    @Test("PokemonListResponse handles nil next URL")
    func handlesNilNext() throws {
        let json = """
            {
                "count": 2,
                "next": null,
                "results": []
            }
            """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let response = try decoder.decode(PokemonListResponse.self, from: json)

        #expect(response.next == nil)
    }
}
