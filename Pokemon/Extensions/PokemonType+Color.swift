//
//  PokemonType+Color.swift
//  Pokemon
//
//  Created by Sylvan  on 05/10/2025.
//

import SwiftUI
import PokemonModels

extension PokemonInfo.TypeEntry {
    var color: Color {
        Color(hex: self.pokemonType.hexColor) ?? .gray
    }
}
