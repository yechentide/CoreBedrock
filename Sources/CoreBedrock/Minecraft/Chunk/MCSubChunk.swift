import Foundation

fileprivate struct StorageLayer {
    static let wordBitSize = 32
    static var wordByteSize: Int {
        wordBitSize / 8
    }
    enum PaletteMetaType: UInt8 {
        case persistence = 0
        case runtime = 1
    }

    let paletteType: PaletteMetaType
    let blocksPerWord: Int
    var bitsPerBlock: Int {
        Self.wordBitSize / blocksPerWord
    }
    var totalWords: Int {
        Int( ceil(16 * 16 * 16 / Double(blocksPerWord)) )
    }
    var blockMask: UInt32 {
        var mask = UInt32(0)
        for _ in 1...bitsPerBlock {
            mask <<= 1
            mask |= 0x1
        }
        return mask
    }
    let blockData: Data
    let palettes: [(tag: CompoundTag, block: MCBlock)]

    private func getBlocksFrom(_ wordData: Data) -> [UInt32] {
        assert(wordData.count == Self.wordByteSize)
        var blocks = [UInt32]()
        var word = wordData.uint32!
        var offset = 0

        while offset < Self.wordBitSize && blocks.count < blocksPerWord {
            let block = word & blockMask
            blocks.append(block)
            word >>= bitsPerBlock
            offset += bitsPerBlock
        }

        return blocks
    }

    private func getBlockFrom(_ wordData: Data, index: Int) -> UInt32 {
        guard (0..<blocksPerWord).contains(index) else {
            fatalError("\(#function): out of range")
        }
        assert(wordData.count == Self.wordByteSize)

        let word = wordData.uint32! >> (bitsPerBlock * index)
        return word & blockMask
    }

    func getBlock(blockOffset: Int) -> MCBlock {
        let wordIndex = ceil(Double(blockOffset) / Double(blocksPerWord)) - 1
        let start = Int(wordIndex) * Self.wordByteSize
        let end = start + Self.wordByteSize
        let wordData = blockData[start..<end]

        let blockIndex = blockOffset % blocksPerWord - 1
        let paletteIndex = getBlockFrom(wordData, index: blockIndex)

        return palettes[Int(paletteIndex)].block
    }

    func getTopVisibleBlocks() -> [MCBlock] {
        var topVisibleBlocks = [MCBlock]()
        var buffer = [UInt32]()

        for i in 0..<totalWords {
            let range = i * Self.wordByteSize ..< (i+1) * Self.wordByteSize
            let wordData = Data(blockData[range])
            buffer.append(contentsOf: getBlocksFrom(wordData))
            if buffer.count < 16 { continue }

            for j in stride(from: 15, through: 0, by: -1) {
                let paletteIndex = Int(buffer[j])
                let block = palettes[paletteIndex].block
                if block.isOpaque {
                    topVisibleBlocks.append(block)
                    if buffer.count > 16 {
                        buffer = [UInt32](buffer[16...])
                    } else {
                        buffer.removeAll()
                    }
                    break
                }
            }
        }

        return topVisibleBlocks
    }
}

fileprivate func parsePalette(_ byte: UInt8) -> (type: StorageLayer.PaletteMetaType, blocksPerWord: Int)? {
    let paletteType = StorageLayer.PaletteMetaType(rawValue: byte & 0x1)!
    let bitsPerBlock = Int(byte >> 1)
    switch bitsPerBlock {
    case 1...6, 8, 16:
        return (paletteType, StorageLayer.wordBitSize / bitsPerBlock)
    default:
        print("Unsupported palette type: \(bitsPerBlock)")
        return nil
    }
}

fileprivate func convertToBlockFrom(tag: CompoundTag) -> MCBlock {
    if let nameTag = tag["name"] as? StringTag {
        return MCBlock(stringLiteral: nameTag.value)
    }
    return .unknown
}

fileprivate func parseStorageLayer(layerData: Data, byteOffset: inout Int) -> StorageLayer? {
    guard let (paletteType, blocksPerWord) = parsePalette(layerData[0]) else { return nil }
    let totalWords = Int(ceil(16 * 16 * 16 / Double(blocksPerWord)))
    let blockDataCount = totalWords * 4
    if layerData.count < 1 + blockDataCount + 4 { return nil }

    var offset = 1 + blockDataCount
    let paletteCount = Data(layerData[offset..<offset+4]).int32!
    offset += 4

    var palettes = [(CompoundTag, MCBlock)]()
    let reader = CBReader(CBBuffer(layerData[offset...]))
    for _ in 0..<paletteCount {
        guard let paletteTag = try? reader.readAsTag() as? CompoundTag else {
            return nil
        }
        let block = convertToBlockFrom(tag: paletteTag)
        palettes.append((paletteTag, block))
        reader.resetState()
    }
    offset += reader.baseStream.position
    byteOffset += offset

    return StorageLayer(paletteType: paletteType,
                        blocksPerWord: blocksPerWord,
                        blockData: layerData[1...blockDataCount],
                        palettes: palettes)
}

public struct MCSubChunk {
    public static let length = 16
    public static let localPosRange = 0..<length
    public static func offset(_ localX: Int, _ localY: Int, _ localZ: Int) -> Int? {
        guard localPosRange ~= localX, localPosRange ~= localY, localPosRange ~= localZ else {
            return nil
        }
        return (localX * length + localZ) * length + localY
    }

    public let x: Int32
    public let yIndex: Int8
    public let z: Int32
    public let version: UInt8
    private let storageLayers: [StorageLayer]

    public var storageLayersCount: Int {
        storageLayers.count
    }

    public static func parseSubChunkData(x: Int32, yIndex:Int8, z: Int32, from subChunkData: Data) -> MCSubChunk? {
        guard subChunkData.count > 4 else { return nil }

        let storageVersion = subChunkData[0]
        assert(storageVersion == 9)

        let storageLayerCount = subChunkData[1]
        let subChunkYIndex = subChunkData[2].data.int8
        guard subChunkYIndex == yIndex else { return nil }

        var offset = 3
        var storageLayers = [StorageLayer]()
        for _ in 1...storageLayerCount {
            if let layer = parseStorageLayer(layerData: Data(subChunkData[offset...]), byteOffset: &offset) {
                storageLayers.append(layer)
            }
        }

        return MCSubChunk(x: x, yIndex: yIndex, z: z, version: storageVersion, storageLayers: storageLayers)
    }

    public func getBlock(_ localX: Int, _ localY: Int, _ localZ: Int) -> MCBlock {
        guard storageLayers.count > 0 else {
            fatalError("\(#function): no storage layers")
        }
        let offset = Self.offset(localX, localY, localZ)!
        let block = storageLayers[0].getBlock(blockOffset: offset)
        return block
    }

    public func getTopVisibleBlocks() -> [MCBlock] {
        return storageLayers[0].getTopVisibleBlocks()
    }
}
