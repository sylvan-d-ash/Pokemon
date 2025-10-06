//
//  ContentView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI
import NetworkKit
import PokemonRepositoryKit

private struct PokemonRepositoryKey: EnvironmentKey {
    static let defaultValue: PokemonRepository = DefaultPokemonRepository(
        localRepo: LocalPokemonRepository(),
        remoteRepo: RemotePokemonRepository(
            network: URLSessionNetworkService(baseURLString: "https://pokeapi.co/api/v2")
        )
    )
}

extension EnvironmentValues {
    var pokemonRepository: PokemonRepository {
        get { self[PokemonRepositoryKey.self] }
        set { self[PokemonRepositoryKey.self] = newValue }
    }
}

struct ContentView: View {
    private let repository: PokemonRepository

    init() {
        let networkService = URLSessionNetworkService(
            baseURLString: "https://pokeapi.co",
            version: .init(value: "v2")
        )
        let localRepository = LocalPokemonRepository()
        let remoteRepository = RemotePokemonRepository(network: networkService)
        repository = DefaultPokemonRepository(
            localRepo: localRepository, remoteRepo: remoteRepository
        )
    }

    var body: some View {
        HomeView(.init(
            service: DefaultPokemonListService(repository: repository)
        ))
        .environment(\.pokemonRepository, repository)
    }
}

#Preview {
    ContentView()
}
