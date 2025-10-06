import Foundation
import NetworkKit
import PokemonModels

public final class RemotePokemonRepository: PokemonRepository {
    private let network: NetworkService
    private let decoder: JSONDecoder
    private let cache = PokemonMemoryCache()

    public init(
        network: NetworkService,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.network = network
        self.decoder = decoder
    }

    public func fetchAllPokemons() async throws -> [PokemonListItem] {
        throw NSError(
            domain: "RemotePokemonRepository", code: -3,
            userInfo: [NSLocalizedDescriptionKey: "Fetching all Pokémon is not supported remotely"]
        )
    }

    public func fetchPokemonDetail(id: Int) async throws -> PokemonInfo {
        // check in-memory cache first
        if let memoryCache = await cache.get(id: id) {
            return memoryCache
        }

        // check disk cache next
        if let cachedResults = try? loadFromDisk(id: id) {
            await cache.set(cachedResults, for: id)
            return cachedResults
        }

        // Otherwise fetch from network
        let endpoint = PokemonEndpoint.info(id: id)
        let pokemonInfo = try await network.request(
            endpoint: endpoint, responseType: PokemonInfo.self
        )

        // Save to cache
        await cache.set(pokemonInfo, for: id)
        saveToDisk(pokemonInfo, for: id)

        return pokemonInfo
    }

    private func cacheURL(for id: Int) -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("pokemon-\(id).json")

    }

    private func saveToDisk(_ info: PokemonInfo, for id: Int) {
        let url = cacheURL(for: id)
        if let data = try? JSONEncoder().encode(info) {
            try? data.write(to: url)
        }
    }

    private func loadFromDisk(id: Int) throws -> PokemonInfo {
        let url = cacheURL(for: id)
        let data = try Data(contentsOf: url)
        return try decoder.decode(PokemonInfo.self, from: data)
    }
}
