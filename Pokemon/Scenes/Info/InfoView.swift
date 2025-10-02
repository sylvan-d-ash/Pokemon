//
//  InfoView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI

struct InfoView: View {
    @StateObject private var viewModel: ViewModel

    init(pokemon: PokemonListItem) {
        _viewModel = .init(wrappedValue: .init(pokemon: pokemon))
    }

    var body: some View {
        Text("Hello universe!")
    }
}
