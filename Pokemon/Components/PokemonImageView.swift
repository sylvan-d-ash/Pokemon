//
//  PokemonImageView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI

struct PokemonImageView: View {
    let url: URL?
    var height: CGFloat = 150

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            case .failure:
                Image(systemName: "xmark.octagon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            @unknown default:
                EmptyView()
            }
        }
    }
}
