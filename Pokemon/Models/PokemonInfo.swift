//
//  PokemonInfo.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

struct PokemonInfo: Decodable {
    struct Stats: Decodable, Hashable {
        struct Stat: Decodable, Hashable {
            let name: String
        }

        let base: Int
        let stat: Stat

        var name: String { stat.name }

        private enum CodingKeys: String, CodingKey {
            case stat
            case base = "base_stat"
        }
    }

    struct PokemonTypes: Decodable, Hashable {
        struct PokemonType: Decodable, Hashable {
            let name: String
        }

        let type: PokemonType

        var name: String { type.name }
    }

    struct Sprites: Decodable {
        let front: String

        private enum CodingKeys: String, CodingKey {
            case front = "front_default"
        }
    }

    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let stats: [Stats]
    let types: [PokemonTypes]
    let sprites: Sprites

    var imageURL: URL? {
        // NOTE: this leads to a very pixalated image
        //return URL(string: sprites.front)

        // use the official art work instead
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }

    var heightInMeters: Double {
        Double(height) * 0.1
    }

    var heightInFeetAndInches: String {
        let heightInFeet = heightInMeters * 3.28084
        let totalInches = Int(round(heightInFeet * 12))
        let feet = totalInches / 12
        let inches = totalInches % 12
        return "\(feet)′\(inches)″"
    }

    var weightInKilograms: Double {
        Double(weight) * 0.1
    }

    var weightInPounds: Double {
        weightInKilograms * 2.20462
    }
}

extension PokemonInfo {
    static var example: PokemonInfo {
        .init(
            id: 1,
            name: "bulbasaur",
            weight: 69,
            height: 7,
            stats: [
                .init(base: 45, stat: .init(name: "hp")),
                .init(base: 49, stat: .init(name: "attack")),
                .init(base: 49, stat: .init(name: "defense")),
                .init(base: 65, stat: .init(name: "sp-attack")),
                .init(base: 65, stat: .init(name: "sp-defense")),
                .init(base: 45, stat: .init(name: "speed")),
            ],
            types: [
                .init(type: .init(name: "grass"))
            ],
            sprites: .init(front: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        )
    }
}
