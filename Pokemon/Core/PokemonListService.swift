//
//  PokemonListService.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

enum PokemonListEndpoint: APIEndpoint {
    case list(count: Int, offset: Int)

    var path: String { "/pokemon" }

    var parameters: [String : Any]? {
        switch self {
        case .list(let count, let offset):
            return ["limit": count, "offset": offset]
        }
    }
}

protocol PokemonListService {
    func fetchPokemons(reset: Bool) async -> Result<[PokemonListItem], Error>
}

final class DefaultPokemonListService: PokemonListService {
    private let repository: PokemonRepository
    private let networkService: NetworkService
    private var count = 0
    private var offset = 0
    private let limit = 10

    init(
        networkService: NetworkService = URLSessionNetworkService(),
        repository: PokemonRepository = PokemonRepository.shared
    ) {
        self.networkService = networkService
        self.repository = repository
    }

    func fetchPokemons(reset: Bool = false) async -> Result<[PokemonListItem], Error> {
        if reset {
            offset = 0
        }

        let pokemons = repository.pokemons
        guard offset < pokemons.count else {
            return .success([])
        }

        let slice = Array(pokemons[offset..<min(offset + limit, pokemons.count)])
        offset += limit
        return .success(slice)
    }

    func fetchFromNetworkService(reset: Bool = false) async -> Result<[PokemonListItem], Error> {
        if reset {
            offset = 0
        }

        let endpoint = PokemonListEndpoint.list(count: limit, offset: offset)
        let results = await networkService.fetch(PokemonListResponse.self, endpoint: endpoint)

        switch results {
        case .success(let success):
            count = success.count
            if count > offset {
                offset += limit
            }
            return .success(success.results)
        case .failure(let error):
            return .failure(error)
        }
    }
}
