// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "NetworkKit",
            targets: ["NetworkKit"]
        )
    ],
    targets: [
        .target(name: "NetworkKit"),
        .testTarget(
            name: "NetworkKitTests",
            dependencies: ["NetworkKit"]
        ),
    ]
)
