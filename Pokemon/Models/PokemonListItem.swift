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

struct PokemonListItem: Decodable, Identifiable, Hashable {
    let name: String
    let id: Int

//    let url: String
//    var apiID: String {
//        guard let id = url.split(separator: "/").last else {
//            return UUID().uuidString
//        }
//
//        return String(id)
//    }

    var imageUrl: URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
}

extension PokemonListItem {
    static var example: PokemonListItem {
        .init(name: "Bulbasaur", id: 1)
    }

    static var listExample: [PokemonListItem] {
        [
            .init(name: "Bulbasaur", id: 1),
            .init(name: "Charmander", id: 2),
            .init(name: "Squirtle", id: 3),
            .init(name: "Pikachu", id: 25),
        ]
    }
}
