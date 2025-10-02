//
//  MockPokemonListService.swift
//  PokemonTests
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation
@testable import Pokemon

final class MockPokemonListService: PokemonListService {
    var mockPokemons: [PokemonListItem] = []
    var shouldFail = false

    func fetchPokemons() async -> Result<[PokemonListItem], Error> {
        if shouldFail {
            return .failure(MockTestError.dummyError)
        }
        return .success(mockPokemons)
    }
}
