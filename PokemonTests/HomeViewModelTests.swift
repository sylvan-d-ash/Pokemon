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
    var service: MockPokemonListService!

    init() {
        service = .init()
        sut = .init(service: service)
    }

    @Test("initial state is empty")
    func testInitialStateIsEmpty() {
        #expect(sut.pokemons.isEmpty)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("fetch pokemons successfully")
    func testFetchPokemonsSuccessfully() async {
        service.mockPokemons = PokemonListItem.listExample
        let count = PokemonListItem.listExample.count

        await sut.fetchPokemons()

        #expect(sut.errorMessage == nil)
        #expect(sut.pokemons.count == count)
        #expect(sut.pokemons.first?.name == "Bulbasaur")
    }

    @Test("fetch pokemons failure")
    func testFetchPokemonsFailure() async {
        service.shouldFail = true

        await sut.fetchPokemons()

        #expect(sut.errorMessage == "Dummy error")
        #expect(sut.pokemons.isEmpty)
    }
}
