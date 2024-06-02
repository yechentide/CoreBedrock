// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreBedrock",
    platforms: [
        .iOS(.v12),
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
    targets: [
        .binaryTarget(
            name: "libz",
            path: "Dependencies/libz.xcframework"
        ),
        .binaryTarget(
            name: "libleveldb",
            path: "Dependencies/libleveldb.xcframework"
        ),

        .target(
            name: "LvDBWrapper",
            dependencies: ["libz", "libleveldb"],
            cxxSettings: [
                .unsafeFlags([
                    "-DDLLX=",
                ])
            ]
        ),
        .testTarget(
            name: "LvDBWrapperTests",
            dependencies: ["LvDBWrapper"],
            resources: [
                .copy("./world"),
            ]
        ),

        .target(
            name: "CoreBedrock",
            dependencies: ["LvDBWrapper"]
        ),
        .testTarget(
            name: "CoreBedrockTests",
            dependencies: ["CoreBedrock"]
        ),
    ],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx11
)
