//
//  MockTestError.swift
//  PokemonTests
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

enum MockTestError: Error {
    case dummyError
}

extension MockTestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dummyError: return "Dummy error"
        }
    }
}
