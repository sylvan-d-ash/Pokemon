//
//  PokemonCardView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI

extension HomeView {
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
}
