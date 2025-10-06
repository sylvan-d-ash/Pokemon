//
//  Info-ViewModel.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation
import PokemonModels

extension InfoView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published private(set) var pokemon: PokemonInfo?
        @Published private(set) var isLoading = false
        @Published private(set) var errorMessage: String?

        var title: String { "#\(item.id) \(item.name.capitalized)" }

        private let item: PokemonListItem
        private let service: PokemonInfoService

        init(pokemon: PokemonListItem, service: PokemonInfoService) {
            self.item = pokemon
            self.service = service
        }

        func fetchDetails() async {
            guard !isLoading else { return }
            isLoading = true
            errorMessage = nil

            let result = await service.fetchPokemonInfo(id: item.id)
            switch result {
            case .success(let pokemon):
                self.pokemon = pokemon
            case .failure(let error):
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
}
