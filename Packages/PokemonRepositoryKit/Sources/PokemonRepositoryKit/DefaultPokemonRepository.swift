import Foundation
import PokemonModels

public final class DefaultPokemonRepository: PokemonRepository {
    private let localRepo: LocalPokemonRepository
    private let remoteRepo: RemotePokemonRepository

    public init(localRepo: LocalPokemonRepository, remoteRepo: RemotePokemonRepository) {
        self.localRepo = localRepo
        self.remoteRepo = remoteRepo
    }

    public func fetchAllPokemons() async throws -> [PokemonListItem] {
        return try await localRepo.fetchAllPokemons()
    }

    public func fetchPokemonDetail(id: Int) async throws -> PokemonInfo {
        return try await remoteRepo.fetchPokemonDetail(id: id)
    }
}
