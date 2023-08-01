// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "picoTools",
    products: [
        .library(name: "picoLib", targets: ["picoLib"]),
        .executable(name: "picoCLI", targets: ["picoCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "picoLib",
            path: "Sources/picoLib"
        ),
        .executableTarget(
            name: "picoCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "picoLib",
            ],
            path: "Sources/picoCLI"
        ),
        .testTarget(
            name: "picoLibTests",
            dependencies: [
                "picoLib",
            ]
        ),
    ]
)
