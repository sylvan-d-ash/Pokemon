// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PokemonModels",
    platforms: [
        .iOS(.v18),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "PokemonModels",
            targets: ["PokemonModels"]
        ),
    ],
    targets: [
        .target(
            name: "PokemonModels"),
        .testTarget(
            name: "PokemonModelsTests",
            dependencies: ["PokemonModels"]
        ),
    ]
)
