//
//  MockPokemonRepository.swift
//  PokemonTests
//
//  Created by Sylvan  on 03/10/2025.
//

import Foundation
@testable import Pokemon

final class MockPokemonRepository: PokemonRepository {
    var mockList: [PokemonListItem] = []
    var shouldFail = false

    func loadPokemonData() -> Result<[PokemonListItem], Error> {
        if shouldFail {
            return .failure(MockTestError.dummyError)
        }
        return .success(mockList)
    }
}
