import Foundation
import PokemonModels

public final class LocalPokemonRepository: PokemonRepository {
    private let fileName: String
    private let bundle: Bundle

    public init(fileName: String = "pokemons", bundle: Bundle = .main) {
        self.fileName = fileName
        self.bundle = bundle
    }

    public func fetchAllPokemons() async throws -> [PokemonListItem] {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw NSError(
                domain: "LocalPokemonRepository", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "JSON file not found"])
        }

        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode([PokemonListItem].self, from: data)
        return response
    }

    public func fetchPokemonDetail(id: Int) async throws -> PokemonInfo {
        throw NSError(
            domain: "LocalPokemonRepository", code: -2,
            userInfo: [NSLocalizedDescriptionKey: "Details not available locally"]
        )
    }
}
