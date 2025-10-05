import Foundation

public struct PokemonListResponse: Decodable, Sendable {
    public let count: Int
    public let next: String?
    public let results: [PokemonListItem]
    
    public init(count: Int, next: String?, results: [PokemonListItem]) {
        self.count = count
        self.next = next
        self.results = results
    }
}
