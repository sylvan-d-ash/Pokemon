//
//  PokemonCardView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI
import UIImageColors
import PokemonModels

extension HomeView {
    struct PokemonCardView: View {
        let pokemon: PokemonListItem
        @State private var colors: UIImageColors?

        var body: some View {
            ZStack {
                (colors?.backgroundColor ?? .gray)
                    .opacity(0.3)

                VStack {
                    PokemonImageView(url: pokemon.imageUrl, colors: $colors)

                    Text("#\(pokemon.id) \(pokemon.name.capitalized)")
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
}
