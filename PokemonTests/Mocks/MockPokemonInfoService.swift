//
//  MockPokemonInfoService.swift
//  PokemonTests
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation
@testable import Pokemon

final class MockPokemonInfoService: PokemonInfoService {
    var mockPokemon: PokemonInfo?
    var shouldFail = false
    func fetchPokemonInfo(id: String) async -> Result<PokemonInfo, Error> {
        if shouldFail {
            return .failure(MockTestError.dummyError)
        }

        guard let mockPokemon else {
            return .failure(MockTestError.notImplemented)
        }

        return .success(mockPokemon)
    }
}
