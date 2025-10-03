//
//  PokemonInfoService.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import Foundation

enum PokemonInfoEndpoint: APIEndpoint {
    case pokemon(id: String)

    var path: String {
        switch self {
        case .pokemon(let id): return "/pokemon/\(id)"
        }
    }

    var parameters: [String : Any]? { nil }
}

protocol PokemonInfoService {
    func fetchPokemonInfo(id: String) async -> Result<PokemonInfo, Error>
}

final class DefaultPokemonInfoService: PokemonInfoService {
    private let networkService: NetworkService

    // simple in-memory cache
    private var cache: [String: PokemonInfo] = [:]

    init(networkService: NetworkService = URLSessionNetworkService()) {
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

        let endpoint = PokemonInfoEndpoint.pokemon(id: id)
        let results = await networkService.fetch(PokemonInfo.self, endpoint: endpoint)

        switch results {
        case .success(let info):
            cache[id] = info
            saveToDisk(info, for: id)
            return .success(info)
        case .failure(let error):
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
