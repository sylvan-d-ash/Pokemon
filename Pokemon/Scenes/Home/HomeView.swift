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
    @Environment(\.pokemonRepository) private var repository

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    init(_ viewModel: ViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
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
                InfoView(.init(
                    pokemon: pokemon,
                    service: DefaultPokemonInfoService(repository: repository)
                ))
            }
            .searchable(text: $viewModel.searchText, prompt: "Search name or number")
            .task { await viewModel.loadPokemons() }
        }
    }
}
