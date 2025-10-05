import Foundation

public struct PokemonListItem: Decodable, Identifiable, Hashable, Sendable {
    public let name: String
    public let id: Int

    public var imageUrl: URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
    
    public init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}

extension PokemonListItem {
    public static var example: PokemonListItem {
        .init(name: "Bulbasaur", id: 1)
    }

    public static var listExample: [PokemonListItem] {
        [
            .init(name: "Bulbasaur", id: 1),
            .init(name: "Charmander", id: 4),
            .init(name: "Squirtle", id: 7),
            .init(name: "Pikachu", id: 25),
        ]
    }
}
