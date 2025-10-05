//
//  Home-ViewModel.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation
import PokemonModels

extension HomeView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published private(set) var isLoading = false
        @Published private(set) var errorMessage: String?
        @Published var searchText: String = ""

        private let service: PokemonListService
        private var allPokemons: [PokemonListItem] = []

        var pokemons: [PokemonListItem] {
            if searchText.isEmpty {
                return allPokemons
            }
            return allPokemons.filter {
                let text = searchText.lowercased().trimmingCharacters(in: .whitespaces)
                return $0.name.lowercased().contains(text) || "\($0.id)".contains(text)
            }
        }

        init(service: PokemonListService) {
            self.service = service
        }

        func loadPokemons() async {
            guard !isLoading else { return }
            isLoading = true
            errorMessage = nil

            let result = await service.fetchPokemons()
            switch result {
            case .success(let pokemons):
                allPokemons = pokemons
            case .failure(let error):
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}
