import Foundation
import PokemonModels

actor PokemonMemoryCache {
    private var cache: [Int: PokemonInfo] = [:]

    func get(id: Int) -> PokemonInfo? {
        return cache[id]
    }

    func set(_ info: PokemonInfo, for id: Int) {
        cache[id] = info
    }

    func clearCache() {
        cache.removeAll()
    }
}
