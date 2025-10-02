//
//  PokemonInfoService.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

protocol PokemonInfoService {
    func fetchPokemonInfo(id: String) async -> Result<PokemonInfo, Error>
}

final class DefaultPokemonInfoService: PokemonInfoService {
    func fetchPokemonInfo(id: String) async -> Result<PokemonInfo, any Error> {
        try? await Task.sleep(for: .seconds(2))
        return .success(PokemonInfo.example)
    }
}
