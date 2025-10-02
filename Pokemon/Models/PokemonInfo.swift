//
//  PokemonInfo.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

struct PokemonInfo: Decodable {
    struct Stats: Decodable {
        struct Stat: Decodable {
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

    struct PokemonTypes: Decodable {
        struct PokemonType: Decodable {
            let name: String
        }

        let base: PokemonType

        var type: String { base.name }

        private enum CodingKeys: String, CodingKey {
            case base = "type"
        }
    }

    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let stats: [Stats]
    let types: [PokemonTypes]
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
                .init(base: .init(name: "grass"))
            ]
        )
    }
}
