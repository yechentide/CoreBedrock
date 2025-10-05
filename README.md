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
    .package(url: "https://github.com/your-username/CoreBedrock", branch: "main")
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
import LvDBWrapper

// Open database
let dbPath = "/path/to/leveldb"
let db = try LvDB(dbPath: dbPath)

// Basic operations
try db.put(Data("myKey".utf8), Data("myValue".utf8))
let value = try db.get(Data("myKey".utf8))
try db.remove(Data("myKey".utf8))

// Batch operations
let batch = LvDBWriteBatch()
batch.put(Data("key1".utf8), value: Data("value1".utf8))
batch.remove(Data("key2".utf8))
try db.writeBatch(batch)
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
print("Game mode: \(world.meta.gameMode)")

// Close the database when done
world.closeDB()
```

## Architecture

CoreBedrock consists of two main modules:

### LvDBWrapper

- Low-level LevelDB C++ wrapper
- Provides Swift-friendly interface to LevelDB operations
- Includes binary dependencies for compression libraries

### CoreBedrock

- High-level Minecraft world manipulation
- NBT parsing and writing
- World metadata management
- Chunk and block operations
- NetEase world support

## Support

|                             | iOS(arm64) | MacOS(arm64) | MacOS(x86) | iOS Simulator(arm64) |
| --------------------------- | :--------: | :----------: | :--------: | :------------------: |
| libleveldb.xcframework      |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |
| libz.xcframework            |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |
| libsnappy.xcframework       |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |
| libzstd.xcframework         |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |
| libcrc32c.xcframework       |     ✔︎      |      ✔︎       |     ✔︎      |          ✔︎           |

**Build XCFrameworks yourself:**
Run the build script to compile all library dependencies from source:
```bash
cd CoreBedrock
git submodule update --init
./Scripts/build.sh
```
This will download and build LevelDB and compression libraries for all supported platforms.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request
