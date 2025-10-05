import Foundation
import Testing

@testable import PokemonModels

@Suite("PokemonListItem Tests")
struct PokemonListItemTests {
    @Test("PokemonListItem decodes from JSON")
    func decodesFromJSON() throws {
        let json = """
            {
                "name": "pikachu",
                "id": 25
            }
            """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let item = try decoder.decode(PokemonListItem.self, from: json)

        #expect(item.name == "pikachu")
        #expect(item.id == 25)
    }

    @Test("Image URL is constructed correctly")
    func imageURL() {
        let item = PokemonListItem.example

        #expect(item.imageUrl?.absoluteString.contains("official-artwork/1.png") == true)
    }

    @Test("Example list contains multiple items")
    func exampleList() {
        let list = PokemonListItem.listExample

        #expect(list.count == 4)
        #expect(list.first?.name == "Bulbasaur")
        #expect(list.last?.name == "Pikachu")
    }

    @Test("PokemonListItem conforms to Identifiable")
    func conformsToIdentifiable() {
        let item = PokemonListItem.example

        // id property should be accessible
        #expect(item.id == 1)
    }

    @Test("PokemonListItem conforms to Hashable")
    func conformsToHashable() {
        let item1 = PokemonListItem(name: "Bulbasaur", id: 1)
        let item2 = PokemonListItem(name: "Bulbasaur", id: 1)
        let item3 = PokemonListItem(name: "Charmander", id: 4)

        #expect(item1 == item2)
        #expect(item1 != item3)
    }
}
