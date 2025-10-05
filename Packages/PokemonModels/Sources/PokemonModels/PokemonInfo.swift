import Foundation

public struct PokemonInfo: Codable, Hashable, Sendable {
    public struct Stat: Codable, Hashable, Sendable {
        public struct StatName: Codable, Hashable, Sendable {
            public let name: String
        }

        public let base: Int
        public let stat: StatName

        public var name: String { stat.name }

        private enum CodingKeys: String, CodingKey {
            case stat
            case base = "base_stat"
        }

        public init(base: Int, stat: StatName) {
            self.base = base
            self.stat = stat
        }
    }

    public struct TypeEntry: Codable, Hashable, Sendable {
        private struct TypeName: Codable, Hashable, Sendable {
            let name: String
        }

        private let type: TypeName

        public var name: String { type.name }

        public var pokemonType: PokemonType {
            PokemonType(rawValue: type.name) ?? .normal
        }

        public init(type: String) {
            self.type = TypeName(name: type)
        }
    }
    public let id: Int
    public let name: String
    public let height: Int
    public let weight: Int  
    public let stats: [Stat]
    public let types: [TypeEntry]

    public var imageURL: URL? {
        // Use the official artwork instead of pixelated sprite
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }

    public var heightInMeters: Double {
        (Double(height) * 0.1)
    }

    public var heightInFeetAndInches: String {
        let heightInFeet = heightInMeters * 3.28084
        let totalInches = Int(round(heightInFeet * 12))
        let feet = totalInches / 12
        let inches = totalInches % 12
        return "\(feet)′\(inches)″"
    }

    public var weightInKilograms: Double {
        Double(weight) * 0.1
    }

    public var weightInPounds: Double {
        weightInKilograms * 2.20462
    }
    
    public init(
        id: Int,
        name: String,
        weight: Int,
        height: Int,
        stats: [Stat],
        types: [TypeEntry]
    ) {
        self.id = id
        self.name = name
        self.weight = weight
        self.height = height
        self.stats = stats
        self.types = types
    }
}

extension PokemonInfo {
    public static var example: PokemonInfo {
        .init(
            id: 1,
            name: "bulbasaur",
            weight: 69,
            height: 7,
            stats: [
                .init(base: 45, stat: .init(name: "hp")),
                .init(base: 49, stat: .init(name: "attack")),
                .init(base: 49, stat: .init(name: "defense")),
                .init(base: 65, stat: .init(name: "special-attack")),
                .init(base: 65, stat: .init(name: "special-defense")),
                .init(base: 45, stat: .init(name: "speed")),
            ],
            types: [
                .init(type: "grass"),
                .init(type: "poison"),
            ],
        )
    }
}
