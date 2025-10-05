//
//  PokemonListService.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation
import PokemonRepositoryKit
import PokemonModels

protocol PokemonListService {
    func fetchPokemons() async -> Result<[PokemonListItem], Error>
}

final class DefaultPokemonListService: PokemonListService {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func fetchPokemons() async -> Result<[PokemonListItem], Error> {
        do {
            let pokemonList = try await repository.fetchAllPokemons()
            return .success(pokemonList)
        } catch {
            return .failure(error)
        }
    }
}
