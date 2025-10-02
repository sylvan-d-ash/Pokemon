//
//  PokemonRepository.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

class PokemonRepository {
    static let shared = PokemonRepository()
    private(set) var pokemons: [PokemonListItem] = []

    private init() {
        loadPokemonData()
    }

    private func loadPokemonData() {
        if let url = Bundle.main.url(forResource: "pokemons", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode([PokemonListItem].self, from: data) {
                self.pokemons = loaded
            }
        }
    }
}
