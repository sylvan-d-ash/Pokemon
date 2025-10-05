//
//  PokemonListService.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation
import NetworkKit

protocol PokemonListService {
    func fetchPokemons(reset: Bool) async -> Result<[PokemonListItem], Error>
}

final class DefaultPokemonListService: PokemonListService {
    private let networkService: NetworkService
    private var count = 0
    private var offset = 0
    private let limit = 10

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchPokemons(reset: Bool = false) async -> Result<[PokemonListItem], Error> {
        if reset {
            offset = 0
        }

        let endpoint = PokemonEndpoint.list(offset: offset, limit: limit)
        do {
            let pokemonList = try await networkService.request(endpoint: endpoint, responseType: PokemonListResponse.self)
            return .success(pokemonList.results)
        } catch {
            return .failure(error)
        }
    }
}
