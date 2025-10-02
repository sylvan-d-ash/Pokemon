//
//  PokemonListService.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

protocol PokemonListService {
    func fetchPokemons() async -> Result<[PokemonListItem], Error>
}

final class DefaultPokemonListService: PokemonListService {
    func fetchPokemons() async -> Result<[PokemonListItem], Error> {
        try? await Task.sleep(for: .seconds(1))
        return .success(PokemonListItem.listExample)
    }
}
