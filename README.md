# CoreBedrock

A Swift library for reading and manipulating Minecraft Bedrock Edition world files, featuring integrated LevelDB support and NBT parsing capabilities.

## Features

- **LevelDB Integration**: Full-featured Swift wrapper for LevelDB operations
- **NBT Support**: Complete implementation of Named Binary Tag format parsing and writing
- **World Management**: Read and manipulate Minecraft Bedrock world files (.mcworld)
- **Chunk Processing**: Load and modify world chunks with block and biome data
- **NetEase Support**: Handle NetEase encrypted world files
- **Cross-Platform**: Supports iOS, iOS Simulator, macOS (Intel & Apple Silicon)

## Installation

### Swift Package Manager

Add CoreBedrock to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/yechentide/core-bedrock", branch: "main")
]
```

Then add the library to your target:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["CoreBedrock"]
    )
]
```

## Quick Start

### LevelDB Operations

```swift
import CoreBedrock

// Open a LevelDB-backed Bedrock database
let dbPath = "/path/to/world/db"
let db = try LevelDB(dbPath: dbPath, createIfMissing: false)

// Basic operations
try db.putData(Data("myValue".utf8), forKey: Data("myKey".utf8))
let value = try db.data(forKey: Data("myKey".utf8))
try db.removeValue(forKey: Data("myKey".utf8))

// Iterate through database entries
let iterator = try db.makeIterator()
iterator.moveToFirst()
while iterator.isValid {
    let key = iterator.currentKey
    let value = iterator.currentValue
    // Process key-value pair
    iterator.moveToNext()
}
iterator.close()

// Close the database when done
db.close()
```

### NBT Operations

```swift
import CoreBedrock

// Create NBT tags
let compound = CompoundTag()
compound["playerName"] = StringTag("Steve")
compound["level"] = IntTag(42)

// Write to binary data
let writer = CBTagWriter()
try writer.write(tag: StringTag(name: "name", "value"))
let data: Data = writer.toData()

// Read from binary data
let reader = CBTagReader(data: data)
let readTag: NBT? = try reader.readNext()
```

### Basic World Operations

```swift
import CoreBedrock

// Open a Minecraft world
let worldURL = URL(fileURLWithPath: "/path/to/world")
let world = try MCWorld(from: worldURL, meta: nil)

// Access world metadata
print("World name: \(world.worldName)")
print("Game mode: \(world.meta.gameMode?.description ?? "unknown")")

// Close the database when done
world.closeDB()
```

## Architecture

CoreBedrock is designed as a unified library with the following components:

### CoreBedrock (Main Library)

- High-level Minecraft world manipulation
- NBT parsing and writing
- World metadata management
- Chunk and block operations
- NetEase world support
- LevelDB database abstraction through the `KeyValueStore` protocol

### LevelDBObjC (Internal Target)

- Low-level LevelDB C++ wrapper bundled within this package
- Provides Swift-friendly interface to LevelDB operations
- Includes binary dependencies for compression and image libraries (libcrc32c, libsnappy, libz, libzstd, libleveldb, libpng, libturbojpeg)
- CoreBedrock consumers only need to add CoreBedrock; image codec consumers can add LibPNG and LibTurboJPEG
- Provides the Objective-C / Objective-C++ bridge layer around LevelDB
- Exposes bridge types such as `LevelDBBridge`, `LevelDBBridgeIterator`, and `LevelDBBridgeWriteBatch` for internal integration

## Support

|                             | iOS(arm64) | MacOS(arm64) | MacOS(x86) | iOS Simulator(arm64) |
| --------------------------- | :--------: | :----------: | :--------: | :------------------: |
| libleveldb.xcframework      |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |
| libz.xcframework            |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |
| libsnappy.xcframework       |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |
| libzstd.xcframework         |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |
| libcrc32c.xcframework       |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |
| libpng.xcframework          |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |
| libturbojpeg.xcframework    |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |

**Build XCFrameworks yourself:**
Run the build script to compile all library dependencies from source:
```bash
cd CoreBedrock
git submodule update --init
./Scripts/build.sh
```
This will download and build LevelDB and compression libraries for all supported platforms.
libpng is built against the bundled libz output from this package, so consumers should link LibPNG when PNG support is needed.
libjpeg-turbo builds arm64 slices with Neon enabled by default and keeps x86_64 SIMD disabled to avoid requiring nasm. Set `LIBJPEG_TURBO_ARM64_NEON=OFF` to disable Neon for arm64 builds.
The classic libjpeg-compatible `libjpeg.xcframework` is not generated by default. Set `BUILD_LIBJPEG_COMPAT_XCFRAMEWORK=ON` if you need the `jpeglib.h` API.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request
