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
        .binaryTarget(
            name: "libpng",
            path: "Libraries/libpng.xcframework"
        ),
        .binaryTarget(
            name: "libturbojpeg",
            path: "Libraries/libturbojpeg.xcframework"
        ),

        .target(
            name: "LevelDBObjC",
            dependencies: ["libcrc32c", "libsnappy", "libz", "libzstd", "libleveldb"],
            cxxSettings: [
                .unsafeFlags([
                    "-DDLLX=",
                ]),
            ]
        ),
        .target(
            name: "ImageCodecC",
            dependencies: ["libpng", "libz", "libturbojpeg"]
        ),
        .testTarget(
            name: "LevelDBObjCTests",
            dependencies: ["LevelDBObjC"],
            resources: [
                .copy("./TestData"),
            ]
        ),

        .target(
            name: "CoreBedrock",
            dependencies: ["LevelDBObjC", "ImageCodecC"],
            swiftSettings: [
                .defaultIsolation(nil),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("InferIsolatedConformances"),
                .enableUpcomingFeature("InternalImportsByDefault"),
                .enableUpcomingFeature("MemberImportVisibility"),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
            ]
        ),
        .testTarget(
            name: "CoreBedrockTests",
            dependencies: ["CoreBedrock"],
            resources: [
                .copy("./TestData"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx11
)
