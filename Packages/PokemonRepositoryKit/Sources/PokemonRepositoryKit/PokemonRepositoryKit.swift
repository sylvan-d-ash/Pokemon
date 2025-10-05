import Foundation
import PokemonModels

public protocol PokemonRepository: Sendable {
    func fetchAllPokemons() async throws -> [PokemonListItem]
    func fetchPokemonDetail(id: Int) async throws -> PokemonInfo
}
