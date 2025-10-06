//
//  PokemonImageView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI
import UIImageColors

struct PokemonImageView: View {
    let url: URL?
    var height: CGFloat = 150
    @Binding var colors: UIImageColors?

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
                    .onAppear {
                        extractColors(from: image)
                    }
            case .failure:
                Image(systemName: "xmark.octagon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            @unknown default:
                Image(systemName: "questionmark.square.dashed")
                    .resizable()
                    .scaledToFit()
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func extractColors(from image: Image) {
        let renderer = ImageRenderer(content: image)
        renderer.scale = UIScreen.main.scale
        renderer.uiImage?.getColors { result in
            DispatchQueue.main.async {
                self.colors = result
            }
        }
    }
}
