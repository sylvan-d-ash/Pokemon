//
//  HomeView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI

struct PokemonCardView: View {
    let pokemon: PokemonListItem
    @State private var bgColor: Color = .gray

    var body: some View {
        ZStack {
            bgColor
                .opacity(0.2)

            VStack {
                AsyncImage(url: pokemon.imageUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    default:
                        ProgressView()
                    }
                }

                Text("#\(pokemon.id) \(pokemon.name)")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(.white)
                    .clipShape(.capsule)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

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
