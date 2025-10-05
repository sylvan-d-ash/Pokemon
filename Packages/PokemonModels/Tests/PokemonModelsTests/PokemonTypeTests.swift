import Foundation
import Testing

@testable import PokemonModels

@Suite("PokemonType Tests")
struct PokemonTypeTests {
    @Test("All Pokemon types have hex colors")
    func allTypesHaveColors() {
        for type in PokemonType.allCases {
            #expect(!type.hexColor.isEmpty)
            #expect(type.hexColor.hasPrefix("#"))
        }
    }

    @Test("Pokemon type decodes from string")
    func decodesFromString() throws {
        let json = "\"fire\"".data(using: .utf8)!
        let decoder = JSONDecoder()
        let type = try decoder.decode(PokemonType.self, from: json)

        #expect(type == .fire)
    }

    @Test("Pokemon type encodes to string")
    func encodesToString() throws {
        let type = PokemonType.water
        let encoder = JSONEncoder()
        let data = try encoder.encode(type)
        let string = String(data: data, encoding: .utf8)

        #expect(string == "\"water\"")
    }
}
