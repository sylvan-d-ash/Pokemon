//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Sylvan  on 02/10/2025.
//

import Testing
@testable import Pokemon

@MainActor
struct PokemonTests {
    var sut: HomeView.ViewModel!

    init() {
        sut = .init()
    }

    @Test("initial state is empty")
    func testInitialStateIsEmpty() {
        #expect(sut.pokemons.isEmpty)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("fetch pokemons successfully")
    func testFetchPokemonsSuccessfully() async {
        await sut.fetchPokemons()

        #expect(sut.errorMessage == nil)
        #expect(sut.pokemons.isEmpty == false)
        #expect(sut.pokemons.first?.name == "Bulbasaur")
    }

    @Test("fetch pokemons failure")
    func testFetchPokemonsFailure() async {
        await sut.fetchPokemons()

        #expect(sut.errorMessage != nil)
        #expect(sut.pokemons.isEmpty)
    }
}
