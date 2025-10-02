//
//  PokemonInfoViewModelTests.swift
//  PokemonTests
//
//  Created by Sylvan  on 02/10/2025.
//

import Testing
@testable import Pokemon

@MainActor
struct PokemonInfoViewModelTests {
    var sut: PokemonInfoView.ViewModel!
    var service: PokemonInfoService!

    init() {
        service = .init()
        sut = .init(service: service)
    }

    @Test("initial state is empty")
    func initialState() {
        #expect(sut.pokemon == nil)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }

    @Test("fetch details successfully")
    func fetchDetailsSuccessfully() async {
        service.mockDetails = PokemonInfo.example

        await sut.fetchDetails()

        #expect(sut.pokemon != nil)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
        #expect(sut.pokemon?.name == "bulbasaur")
        #expect(sut.pokemon?.stats.first?.name == "hp")
        #expect(sut.pokemon?.stats.first?.name == "45")
        #expect(sut.pokemon?.types.first?.type == "grass")
    }

    @Test("fetch details failure")
    func fetchDetailsFailure() async {
        service.shouldFail = true

        await sut.fetchDetails()

        #expect(sut.pokemon == nil)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == "Dummy error")
    }
}
