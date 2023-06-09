import Foundation

public class MCSubChunk {
    static let totalBlockCount = 4096 // 16 * 16 * 16
    public static let localPosRange = 0..<MCChunk.length
    public static func offset(_ localX: Int, _ localY: Int, _ localZ: Int) -> Int? {
        guard localPosRange ~= localX, localPosRange ~= localY, localPosRange ~= localZ else {
            return nil
        }
        return (localX * MCChunk.length + localZ) * MCChunk.length + localY
    }

    public let x: Int32
    public let yIndex: Int8
    public let z: Int32
    public let version: UInt8

    public let biomeLayer: MCBiomeLayer
    public let blockLayers: [MCBlockLayer]

    public init(x: Int32, yIndex: Int8, z: Int32, version: UInt8, biomeLayer: MCBiomeLayer, blockLayers: [MCBlockLayer]) {
        self.x = x
        self.yIndex = yIndex
        self.z = z
        self.version = version
        self.biomeLayer = biomeLayer
        self.blockLayers = blockLayers
    }

    public func getBlock(_ localX: Int, _ localY: Int, _ localZ: Int) -> MCBlock? {
        guard blockLayers.count > 0 else {
            print("\(#function): no storage layers")
            return nil
        }
        guard let offset = Self.offset(localX, localY, localZ) else {
            print("\(#function): wrong postions")
            return nil
        }

        let index = blockLayers[0].map[offset]
        return blockLayers[0].palettes[Int(index)]
    }

    public func getBiome(_ localX: Int, _ localY: Int, _ localZ: Int) -> MCBiomeType? {
        guard let offset = Self.offset(localX, localY, localZ) else {
            print("\(#function): wrong postions")
            return nil
        }
        let index = biomeLayer.map[offset]
        return biomeLayer.palettes[Int(index)]
    }

    public func getTopDownBlocks(_ localX: Int, _ localZ: Int) -> [MCBlock]? {
        guard blockLayers.count > 0 else {
            print("\(#function): no storage layers")
            return nil
        }
        guard let offset = Self.offset(localX, 0, localZ) else {
            print("\(#function): wrong postions")
            return nil
        }

        let topDownBlocks = stride(from: offset+MCChunk.length, through: offset, by: -1).map {
            let index = blockLayers[0].map[$0]
            return blockLayers[0].palettes[Int(index)]
        }
        return topDownBlocks
    }

    public func getTopDownBiomes(_ localX: Int, _ localZ: Int) -> [MCBiomeType]? {
        guard let offset = Self.offset(localX, 0, localZ) else {
            print("\(#function): wrong postions")
            return nil
        }
        if biomeLayer.palettes.count == 1 {
            return biomeLayer.palettes
        }

        let topDownBiomes = stride(from: offset+MCChunk.length, through: offset, by: -1).map {
            let index = biomeLayer.map[$0]
            return biomeLayer.palettes[Int(index)]
        }
        return topDownBiomes
    }
}
