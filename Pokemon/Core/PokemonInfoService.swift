//
//  PokemonInfoService.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation
import PokemonModels
import PokemonRepositoryKit

protocol PokemonInfoService {
    func fetchPokemonInfo(id: Int) async -> Result<PokemonInfo, Error>
}

final class DefaultPokemonInfoService: PokemonInfoService {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func fetchPokemonInfo(id: Int) async -> Result<PokemonInfo, Error> {
        do {
            let pokemonInfo = try await repository.fetchPokemonDetail(id: id)
            return .success(pokemonInfo)
        } catch {
            return .failure(error)
        }
    }
}
