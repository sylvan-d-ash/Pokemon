//
//  HomeView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI
import PokemonModels

struct HomeView: View {
    @StateObject private var viewModel: ViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    init() {
        _viewModel = .init(wrappedValue: .init())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading && viewModel.pokemons.isEmpty {
                    ProgressView("Loading...")
                } else if viewModel.errorMessage != nil && viewModel.pokemons.isEmpty {
                    Text(viewModel.errorMessage!)
                        .foregroundStyle(.red)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.pokemons) { pokemon in
                            NavigationLink(value: pokemon) {
                                PokemonCardView(pokemon: pokemon)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Pokemons")
            .navigationDestination(for: PokemonListItem.self) { pokemon in
                InfoView(pokemon: pokemon)
            }
            .searchable(text: $viewModel.searchText, prompt: "Search name or number")
            .onAppear { viewModel.loadPokemons() }
        }
    }
}

#Preview("Dark") {
    HomeView()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    HomeView()
}
