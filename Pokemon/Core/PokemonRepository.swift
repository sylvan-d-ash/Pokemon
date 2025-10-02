//
//  PokemonRepository.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

enum RepositoryError: Error, LocalizedError {
    case fileNotFound
    case decodingFailed
    case failedToReadFile

    var errorDescription: String? {
        switch self {
        case .fileNotFound: return "Pokemon file not found"
        case .decodingFailed: return "Decoding failed"
        case .failedToReadFile: return "Failed to read file"
        }
    }
}

protocol PokemonRepository {
    func loadPokemonData() -> Result<[PokemonListItem], Error>
}

final class DefaultPokemonRepository: PokemonRepository {
    func loadPokemonData() -> Result<[PokemonListItem], Error> {
        guard let url = Bundle.main.url(forResource: "pokemons", withExtension: "json") else {
            return .failure(RepositoryError.fileNotFound)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let results = try decoder.decode([PokemonListItem].self, from: data)
            return .success(results)
        } catch _ as DecodingError {
            return .failure(RepositoryError.decodingFailed)
        } catch {
            return .failure(RepositoryError.failedToReadFile)
        }
    }
}
