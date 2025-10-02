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
