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
    var service: MockPokemonRepository!

    init() {
        service = .init()
        sut = .init(service: service)
    }

    @Test("fetch pokemons successfully")
    func testFetchPokemonsSuccessfully() {
        service.mockList = PokemonListItem.listExample
        let count = PokemonListItem.listExample.count

        sut.loadPokemons()

        #expect(sut.errorMessage == nil)
        #expect(sut.pokemons.count == count)
        #expect(sut.pokemons.first?.name == "Bulbasaur")
    }

    @Test("fetch pokemons failure")
    func testFetchPokemonsFailure() {
        service.shouldFail = true

        sut.loadPokemons()

        #expect(sut.errorMessage == "Dummy error")
        #expect(sut.pokemons.isEmpty)
    }

    @Test("search by name or id")
    func testSearchByName() {
        let mocks = PokemonListItem.listExample
        let count = mocks.count
        service.mockList = mocks

        sut.loadPokemons()

        #expect(sut.pokemons.count == count)

        sut.searchText = "pik"
        #expect(sut.pokemons.count == 1)
        #expect(sut.pokemons.first?.id == 25)

        sut.searchText = "2"
        #expect(sut.pokemons.count == 2)
        #expect(sut.pokemons.first?.id == 2)

        sut.searchText = ""
        #expect(sut.pokemons.count == count)

        sut.searchText = "random"
        #expect(sut.pokemons.isEmpty)
    }
}
