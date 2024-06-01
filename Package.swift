// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreBedrock",
    products: [
        .library(
            name: "CoreBedrock",
            targets: ["CoreBedrock"]
        ),
    ],
    targets: [
        .target(
            name: "CoreBedrock"
        ),
        .testTarget(
            name: "CoreBedrockTests",
            dependencies: ["CoreBedrock"]
        ),
    ]
)
