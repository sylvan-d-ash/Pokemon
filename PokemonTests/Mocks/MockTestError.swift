//
//  MockTestError.swift
//  PokemonTests
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

enum MockTestError: Error {
    case notImplemented
    case dummyError
}

extension MockTestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notImplemented: return "Not implemented"
        case .dummyError: return "Dummy error"
        }
    }
}
