// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PokemonRepositoryKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "PokemonRepositoryKit",
            targets: ["PokemonRepositoryKit"])
    ],
    dependencies: [
        .package(path: "../NetworkKit"),
        .package(path: "../PokemonModels"),
    ],
    targets: [
        .target(
            name: "PokemonRepositoryKit",
            dependencies: ["NetworkKit", "PokemonModels"]
        ),
        .testTarget(
            name: "PokemonRepositoryKitTests",
            dependencies: ["PokemonRepositoryKit"]
        ),
    ]
)
