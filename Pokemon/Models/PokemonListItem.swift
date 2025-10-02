//
//  PokemonListItem.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

struct PokemonListResponse: Decodable {
    let count: Int
    let next: String?
    let results: [PokemonListItem]
}

struct PokemonListItem: Decodable {
    let name: String
    let url: String

    var id: String {
        guard let id = url.split(separator: "/").last else {
            return UUID().uuidString
        }

        return String(id)
    }

    var imageUrl: URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
}

extension PokemonListItem {
    static var example: PokemonListItem {
        .init(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
    }

    static var listExample: [PokemonListItem] {
        [
            .init(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
            .init(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/2/"),
            .init(name: "Squirtle", url: "https://pokeapi.co/api/v2/pokemon/3/"),
            .init(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            .init(name: "Jigglypuff", url: "https://pokeapi.co/api/v2/pokemon/115/"),
            .init(name: "Wartortle", url: "https://pokeapi.co/api/v2/pokemon/9/"),
        ]
    }
}
