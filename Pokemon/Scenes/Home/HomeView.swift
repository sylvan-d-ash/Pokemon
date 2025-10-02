//
//  HomeView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI

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
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
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
            .task { await viewModel.fetchPokemons() }
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
