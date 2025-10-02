//
//  PokemonType.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI

enum PokemonType: String, CaseIterable, Codable {
    case normal, fire, water, electric, grass, ice
    case fighting, poison, ground, flying, psychic
    case bug, rock, ghost, dragon, dark, steel, fairy

    var color: Color {
        switch self {
        case .normal: return .gray
        case .fire: return .red
        case .water: return .blue
        case .electric: return .yellow
        case .grass: return .green
        case .ice: return .cyan
        case .fighting: return .orange
        case .poison: return .purple
        case .ground: return .brown
        case .flying: return .indigo
        case .psychic: return .pink
        case .bug: return .mint
        case .rock: return .secondary
        case .ghost: return .black
        case .dragon: return .teal
        case .dark: return .gray.opacity(0.8)
        case .steel: return .gray.opacity(0.6)
        case .fairy: return .pink.opacity(0.7)
        }
    }
}

