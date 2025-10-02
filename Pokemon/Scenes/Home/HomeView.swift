//
//  HomeView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: ViewModel
    @State private var search: String = ""

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

                    Button("Reload") {
                        viewModel.fetchPokemons()
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.pokemons) { pokemon in
                            NavigationLink(value: pokemon) {
                                PokemonCardView(pokemon: pokemon)
                            }
                            .onAppear {
                                // Load next batch when last item appears
                                if pokemon == viewModel.pokemons.last {
                                    viewModel.loadMorePokemons()
                                }
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
            .searchable(text: $search, prompt: "Search name or number")
            .onAppear { viewModel.fetchPokemons() }
            .refreshable { viewModel.fetchPokemons() }
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
