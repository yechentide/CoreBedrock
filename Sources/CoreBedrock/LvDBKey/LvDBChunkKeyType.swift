//
// Created by yechentide on 2024/10/04
//

// swiftlint:disable line_length
// swiftformat:disable consecutiveSpaces spaceAroundOperators

///  Key types in leveldb.
///
///  [Chunk key format](https://minecraft.fandom.com/wiki/Bedrock_Edition_level_format)
///
///  [Non-Actor Data Chunk Key IDs](https://docs.microsoft.com/en-us/minecraft/creator/documents/actorstorage)
public enum LvDBChunkKeyType: UInt8, CaseIterable, Sendable {
    public static let keyTypeStartWith: UInt8 = 0x2B

    case data3D                 = 0x2B
    case chunkVersion           = 0x2C      // This was moved to the front as needed for the extended heights feature. Old chunks will not have this data.
    case subChunkPrefix         = 0x2F      // Terrain for a 16×16×16 subchunk
    case blockEntity            = 0x31      // Block entity data (little-endian NBT)
    case pendingTicks           = 0x33      // Pending tick data (little-endian NBT)
    case biomeState             = 0x35
    case finalizedState         = 0x36      // A 32-bit little endian integer
    case conversionData         = 0x37      // data that the converter provides, that are used at runtime for things like blending
    case borderBlocks           = 0x38      // Education Edition Feature
    case hardcodedSpawners      = 0x39      // Bounding boxes for structure spawns stored in binary format
    case randomTicks            = 0x3A      // Random tick data (little-endian NBT)
    case checkSums              = 0x3B      // xxHash checksums of other chunk records
    case generationSeed         = 0x3C
    case metaDataHash           = 0x3F
    case blendingData           = 0x40
    case actorDigestVersion     = 0x41
    case aabbVolumes            = 0x77

    // legacy key types
    case data2D                 = 0x2D              // Biomes and elevation
    case entity                 = 0x32              // Entity data (little-endian NBT)
    case legacyData2D           = 0x2E
    case legacyTerrain          = 0x30              // Terrain for an entire chunk
    case legacyBlockExtraData   = 0x34
    case generatedPreCavesAndCliffsBlending = 0x3D  // not used, DON'T REMOVE
    case blendingBiomeHeight    = 0x3E              // not used, DON'T REMOVE
    case legacyChunkVersion     = 0x76
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
// swiftlint:enable line_length
