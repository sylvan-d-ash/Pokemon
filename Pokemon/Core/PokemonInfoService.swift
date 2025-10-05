//
//  PokemonInfoService.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation
import NetworkKit
import PokemonModels

enum PokemonEndpoint: Endpoint {
    case list(offset: Int, limit: Int)
    case info(id: String)

    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    var body: Data? { nil }

    var path: String {
        switch self {
        case .list: "/pokemon"
        case .info(let id): "/pokemon/\(id)"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let offset, let limit):
            return [
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)"),
            ]
        case .info: return nil
        }
    }
}

protocol PokemonInfoService {
    func fetchPokemonInfo(id: String) async -> Result<PokemonInfo, Error>
}

final class DefaultPokemonInfoService: PokemonInfoService {
    private let networkService: NetworkService

    // simple in-memory cache
    private var cache: [String: PokemonInfo] = [:]

    init(
        networkService: NetworkService = URLSessionNetworkService(baseURLString: "https://pokeapi.co/api/v2")
    ) {
        self.networkService = networkService
    }

    func fetchPokemonInfo(id: String) async -> Result<PokemonInfo, Error> {
        if let memoryCache = cache[id] {
            return .success(memoryCache)
        }

        let cachedResults = loadFromDisk(id: id)
        if case let .success(diskCache) = cachedResults {
            cache[id] = diskCache
            return .success(diskCache)
        }

        let endpoint = PokemonEndpoint.info(id: id)
        do {
            let pokemonInfo = try await networkService.request(endpoint: endpoint, responseType: PokemonInfo.self)
            saveToDisk(pokemonInfo, for: id)
            return .success(pokemonInfo)
        } catch {
            return .failure(error)
        }
    }

    private func cacheURL(for id: String) -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("pokemon-\(id).json")

    }

    private func saveToDisk(_ info: PokemonInfo, for id: String) {
        let url = cacheURL(for: id)
        if let data = try? JSONEncoder().encode(info) {
            try? data.write(to: url)
        }
    }

    private func loadFromDisk(id: String) -> Result<PokemonInfo, Error> {
        let url = cacheURL(for: id)

        do {
            let data = try Data(contentsOf: url)
            let info = try JSONDecoder().decode(PokemonInfo.self, from: data)
            return .success(info)
        } catch _ as DecodingError {
            return .failure(RepositoryError.decodingFailed)
        } catch {
            return .failure(RepositoryError.failedToReadFile)
        }
    }
}
