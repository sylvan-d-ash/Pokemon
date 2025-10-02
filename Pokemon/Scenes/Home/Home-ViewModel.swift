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
            isLoading = true
            errorMessage = nil
            try? await Task.sleep(for: .seconds(2))
            pokemons = PokemonListItem.listExample
            isLoading = false
        }
    }
}
