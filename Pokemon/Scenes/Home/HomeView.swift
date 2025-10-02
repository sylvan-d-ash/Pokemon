//
//  HomeView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI

struct PokemonRow: View {
    let id: String
    let name: String
    let imageURL: URL?
    @State private var bgColor: Color = .gray

    var body: some View {
        ZStack {
            bgColor
                .opacity(0.2)

            VStack {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    default:
                        ProgressView()
                    }
                }

                Text("#\(id) \(name)")
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
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.pokemons) { pokemon in
                        PokemonRow(
                            id: pokemon.id,
                            name: pokemon.name,
                            imageURL: pokemon.imageUrl
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Pokemons")
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
