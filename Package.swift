// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "core-bedrock",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "LvDBWrapper",
            targets: ["LvDBWrapper"]
        ),
        .library(
            name: "CoreBedrock",
            targets: ["CoreBedrock"]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "libcrc32c",
            path: "Libraries/libcrc32c.xcframework"
        ),
        .binaryTarget(
            name: "libsnappy",
            path: "Libraries/libsnappy.xcframework"
        ),
        .binaryTarget(
            name: "libz",
            path: "Libraries/libz.xcframework"
        ),
        .binaryTarget(
            name: "libzstd",
            path: "Libraries/libzstd.xcframework"
        ),
        .binaryTarget(
            name: "libleveldb",
            path: "Libraries/libleveldb.xcframework"
        ),

        .target(
            name: "LvDBWrapper",
            dependencies: ["libcrc32c", "libsnappy", "libz", "libzstd", "libleveldb"],
            cxxSettings: [
                .unsafeFlags([
                    "-DDLLX=",
                ]),
            ]
        ),
        .testTarget(
            name: "LvDBWrapperTests",
            dependencies: ["LvDBWrapper"],
            resources: [
                .copy("./TestData"),
            ]
        ),

        .target(
            name: "CoreBedrock",
            dependencies: [ "LvDBWrapper" ],
            swiftSettings: [
                .defaultIsolation(MainActor.self),
            ]
        ),
        .testTarget(
            name: "CoreBedrockTests",
            dependencies: ["CoreBedrock"],
            resources: [
                .copy("./TestData"),
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self),
            ]
        ),
    ],
    swiftLanguageModes: [.v6],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx11
)
