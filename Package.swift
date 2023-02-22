// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreBedrock",
    platforms: [
        .macOS(.v11),
        .iOS(.v11)
    ],
    products: [
        .library(name: "CoreBedrock", targets: ["CoreBedrock"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/yechentide/LvDBWrapper", exact: "1.0.0"),
        .package(url: "https://github.com/yechentide/LvDBWrapper", branch: "main"),
        .package(url: "https://github.com/mw99/DataCompression", exact: "3.8.0")
    ],
    targets: [
        .target(name: "CoreBedrock",
                dependencies: ["LvDBWrapper", "DataCompression"],
                resources: [
                    .process("./Extensions/endian.md")
                ]),
        .testTarget(name: "CoreBedrockTests",
                    dependencies: ["CoreBedrock"],
                    resources: [
                        .process("TestData"),
                        .copy("TestWorld")
                    ]),
    ]
)
