//
//  Home-ViewModel.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

extension HomeView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published private(set) var pokemons: [PokemonListItem] = []
        @Published private(set) var isLoading = false
        @Published private(set) var errorMessage: String?

        private let service: PokemonListService

        init(service: PokemonListService = DefaultPokemonListService()) {
            self.service = service
        }

        func fetchPokemons() {
            pokemons = []
            Task { await fetch(isInitial: true) }
        }

        func loadMorePokemons() {
            Task { await fetch(isInitial: false) }
        }

        private func fetch(isInitial: Bool) async {
            guard !isLoading else { return }
            isLoading = true
            errorMessage = nil

            let result = await service.fetchPokemons(reset: isInitial)
            switch result {
            case .success(let pokemons):
                self.pokemons.append(contentsOf: pokemons)
            case .failure(let error):
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}
