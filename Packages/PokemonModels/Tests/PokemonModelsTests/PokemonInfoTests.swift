import Foundation
import Testing

@testable import PokemonModels

@Suite("PokemonInfo Tests")
struct PokemonInfoTests {
    @Test("PokemonInfo decodes from JSON correctly")
    func decodesFromJSON() throws {
        let json = """
            {
                "id": 1,
                "name": "bulbasaur",
                "height": 7,
                "weight": 69,
                "stats": [
                    {
                        "base_stat": 45,
                        "stat": {
                            "name": "hp"
                        }
                    }
                ],
                "types": [
                    {
                        "type": {
                            "name": "grass"
                        }
                    }
                ],
                "sprites": {
                    "front_default": "https://example.com/bulbasaur.png"
                }
            }
            """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let pokemon = try decoder.decode(PokemonInfo.self, from: json)

        #expect(pokemon.id == 1)
        #expect(pokemon.name == "bulbasaur")
        #expect(pokemon.height == 7)
        #expect(pokemon.weight == 69)
        #expect(pokemon.stats.count == 1)
        #expect(pokemon.stats.first?.base == 45)
        #expect(pokemon.types.count == 1)
        #expect(pokemon.types.first?.name == "grass")
    }

    @Test("Height conversion to meters is correct")
    func heightInMeters() {
        let pokemon = PokemonInfo.example

        // height is 7 decimeters = 0.7 meters
        expectApproximatelyEqual(pokemon.heightInMeters, 0.7)
    }

    @Test("Height conversion to feet and inches is correct")
    func heightInFeetAndInches() {
        let pokemon = PokemonInfo.example

        // 0.7 meters ≈ 2'4"
        #expect(pokemon.heightInFeetAndInches.contains("2"))
    }

    @Test("Weight conversion to kilograms is correct")
    func weightInKilograms() {
        let pokemon = PokemonInfo.example

        // weight is 69 hectograms = 6.9 kg
        expectApproximatelyEqual(pokemon.weightInKilograms, 6.9)
    }

    @Test("Weight conversion to pounds is correct")
    func weightInPounds() {
        let pokemon = PokemonInfo.example

        // 6.9 kg ≈ 15.2 lbs
        #expect(pokemon.weightInPounds > 15.1 && pokemon.weightInPounds < 15.3)
    }

    @Test("Image URL is constructed correctly")
    func imageURL() {
        let pokemon = PokemonInfo.example

        #expect(pokemon.imageURL?.absoluteString.contains("official-artwork/1.png") == true)
    }

    @Test("Stats name is accessible through nested property")
    func statsName() {
        let pokemon = PokemonInfo.example

        #expect(pokemon.stats.first?.name == "hp")
    }

    @Test("Pokemon type is accessible and converts to PokemonType enum")
    func pokemonType() {
        let pokemon = PokemonInfo.example

        #expect(pokemon.types.first?.name == "grass")
        #expect(pokemon.types.first?.pokemonType == .grass)
    }
}

private func expectApproximatelyEqual(
    _ actual: Double, _ expected: Double, tolerance: Double = 0.0001,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    #expect(abs(actual - expected) < tolerance, sourceLocation: sourceLocation)
}
