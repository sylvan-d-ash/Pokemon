//
//  InfoView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI

struct InfoView: View {
    @StateObject private var viewModel: ViewModel
    @State private var bgColor: Color = .gray

    init(pokemon: PokemonListItem) {
        _viewModel = .init(wrappedValue: .init(pokemon: pokemon))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let pokemon = viewModel.pokemon {
                ZStack(alignment: .top) {
                    bgColor
                        .opacity(0.2)

                    ScrollView {
                        VStack(spacing: 16) {
                            AsyncImage(url: pokemon.imageURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                } else {
                                    ProgressView()
                                }
                            }

                            Text("\(pokemon.name.capitalized)")
                                .font(.title)
                                .bold()

                            typesView(pokemon)

                            heightAndWeightView(pokemon)
                                .font(.headline)
                                .padding()
                                .foregroundStyle(.black)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            statsView(pokemon)
                                .padding()
                                .foregroundStyle(.black)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            Spacer()
                        }
                    }
                    .padding()
                }
            } else if let error = viewModel.errorMessage {
                Text("An error occured: \(error)")
                    .foregroundStyle(.red)
            } else {
                EmptyView()
            }
        }
        .navigationTitle(viewModel.title)
        .task { await viewModel.fetchDetails() }
    }

    private func typesView(_ pokemon: PokemonInfo) -> some View {
        HStack {
            ForEach(pokemon.types, id: \.self) { type in
                Text(type.name.uppercased())
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(.blue.opacity(0.2))
                    .clipShape(.capsule)
            }
        }
    }

    private func heightAndWeightView(_ pokemon: PokemonInfo) -> some View {
        HStack {
            VStack(spacing: 8) {
                Text("Height")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(pokemon.height)") // decimetres
            }
            .frame(maxWidth: .infinity)

            Divider()

            VStack(spacing: 8) {
                Text("Weight")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(pokemon.weight)") // hectograms
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func statsView(_ pokemon: PokemonInfo) -> some View {
        VStack(spacing: 8) {
            ForEach(pokemon.stats, id: \.self) { stat in
                HStack {
                    Text(stat.name.capitalized)
                        .frame(width: 90, alignment: .leading)

                    Text("\(stat.base)")
                        .frame(width: 40)

                    ProgressView(value: Double(stat.base), total: 255)
                        .progressViewStyle(.linear)
                        .tint(.green)
                        .frame(height: 5)
                }
                .font(.subheadline)
            }
        }
    }
}
