//
//  PokemonInfoService.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

enum PokemonInfoEndpoint: APIEndpoint {
    case pokemon(id: String)

    var path: String {
        switch self {
        case .pokemon(let id): return "/pokemon/\(id)/"
        }
    }

    var parameters: [String : Any]? { nil }
}

protocol PokemonInfoService {
    func fetchPokemonInfo(id: String) async -> Result<PokemonInfo, Error>
}

final class DefaultPokemonInfoService: PokemonInfoService {
    private let networkService: NetworkService

    init(networkService: NetworkService = URLSessionNetworkService()) {
        self.networkService = networkService
    }

    func fetchPokemonInfo(id: String) async -> Result<PokemonInfo, Error> {
        let endpoint = PokemonInfoEndpoint.pokemon(id: id)
        return await networkService.fetch(PokemonInfo.self, endpoint: endpoint)
//        try? await Task.sleep(for: .seconds(2))
//        return .success(PokemonInfo.example)
    }
}
