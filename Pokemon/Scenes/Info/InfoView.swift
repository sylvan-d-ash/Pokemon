//
//  InfoView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI
import UIImageColors
import PokemonModels

struct InfoView: View {
    @StateObject private var viewModel: ViewModel
    @State private var colors: UIImageColors?

    init(_ viewModel: ViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let pokemon = viewModel.pokemon {
                ZStack(alignment: .top) {
                    backgroundColorView
                        .opacity(0.2)
                        .ignoresSafeArea()

                    ScrollView {
                        VStack(spacing: 16) {
                            PokemonImageView(url: pokemon.imageURL, height: 200, colors: $colors)

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

                Button("Reload") {
                    Task { await viewModel.fetchDetails() }
                }
                .buttonStyle(.borderedProminent)
            } else {
                EmptyView()
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.fetchDetails() }
    }

    @ViewBuilder
    private var backgroundColorView: some View {
        if let colors {
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        colors.backgroundColor,
                        colors.primaryColor,
                        colors.secondaryColor,
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            Color.gray
        }
    }

    private func typesView(_ pokemon: PokemonInfo) -> some View {
        HStack {
            ForEach(pokemon.types, id: \.self) { type in
                Text(type.name.uppercased())
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(type.color.opacity(0.3))
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

                Text("\(pokemon.heightInMeters, specifier: "%.2f") m (\(pokemon.heightInFeetAndInches) ft)")
            }
            .frame(maxWidth: .infinity)

            Divider()

            VStack(spacing: 8) {
                Text("Weight")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(pokemon.weightInKilograms, specifier: "%.1f") kg (\(pokemon.weightInPounds, specifier: "%.1f") lbs)")
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text("\(stat.base)")
                        .frame(width: 40)

                    ProgressView(value: Double(stat.base), total: 255)
                        .progressViewStyle(.linear)
                        .tint(.green)
                }
                .font(.subheadline)
            }
        }
    }
}
