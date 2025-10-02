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

        func fetchPokemons() async {
            guard !isLoading else { return }
            isLoading = true
            errorMessage = nil

            let result = await service.fetchPokemons()
            switch result {
            case .success(let pokemons):
                self.pokemons = pokemons
            case .failure(let error):
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}
