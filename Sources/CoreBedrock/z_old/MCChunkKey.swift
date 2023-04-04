import Foundation

public struct MCChunkKey: MCArea {
    public static var length: Int32 = 16
    public var xIndex: Int32
    public var zIndex: Int32
    
    /// chunkKeyTypes storage format (big-endian):
    /// 0b xxxx_xxxx_0000_0000_0000_0000_0000_0000      // 23<-----0
    private(set) var types: UInt32       = 0b00000000_00000000_00000000_00000000
    
    /// World Height = -64 ~ 319
    /// subChunkIndex = -4 ~ 20
    /// subChunkIndex storage format (big-endian):
    /// 0b xxxx_xxxx_0000_0000_0000_0000_0000_0000      // 24<-----0   (20 <-- -4)
    private(set) var subChunks: UInt32   = 0b00000000_00000000_00000000_00000000
    
    public init(xIndex: Int32, zIndex: Int32) {
        self.xIndex = xIndex
        self.zIndex = zIndex
    }
    
    public init(xIndex: Int32, zIndex: Int32, types: UInt32 = 0, subChunks: UInt32 = 0) {
        self.xIndex = xIndex
        self.zIndex = zIndex
        self.types = types
        self.subChunks = subChunks
    }
    
    public static let minimumSubChunkIndex: Int8 = -4
    
    public static func bitOffset(subChunkIndex: Int8) -> UInt8 {
        let offset = UInt8(subChunkIndex - minimumSubChunkIndex)
        guard 0 <= offset, offset < UInt32.bitWidth else {
            fatalError("Error: wrong index for subChunk")
        }
        return offset
    }
    
    public static func bitOffset(chunkKeyType: MCChunkKeyType) -> UInt8 {
        let offset = chunkKeyType.rawValue - MCChunkKeyType.keyTypeStartWith
        guard 0 <= offset, offset < UInt32.bitWidth else {
            fatalError("Error: wrong key type for subChunk")
        }
        return offset
    }
    
    public func generateKeyData(dimension: MCDimension) -> [Data] {
        var keyDataArray = [Data]()
        
        var keyPrefix = Data()
        if dimension != .overworld {
            keyPrefix.append(dimension.rawValue.data)
        }
        keyPrefix.append(xIndex.data)
        keyPrefix.append(zIndex.data)
        
        for type in existTypes() {
            guard type != .subChunkPrefix else { continue }
            let data = keyPrefix + type.rawValue.data
            keyDataArray.append(data)
        }
        for subChunkIndex in existSubChunks() {
            let data = keyPrefix + MCChunkKeyType.subChunkPrefix.rawValue.data + subChunkIndex.data
            keyDataArray.append(data)
        }
        
        return keyDataArray
    }
}

extension MCChunkKey {
    public mutating func addSubChunk(index: Int8) {
        if subChunks == 0 {
            let subChunkTypeOffset = Self.bitOffset(chunkKeyType: .subChunkPrefix)
            types.bitOn(offset: subChunkTypeOffset)
        }
        
        let offset = Self.bitOffset(subChunkIndex: index)
        subChunks.bitOn(offset: offset)
    }
    
    public mutating func deleteSubChunk(index: Int8) {
        let offset = Self.bitOffset(subChunkIndex: index)
        subChunks.bitOff(offset: offset)
        
        if subChunks == 0 {
            let subChunkTypeOffset = Self.bitOffset(chunkKeyType: .subChunkPrefix)
            types.bitOff(offset: subChunkTypeOffset)
        }
    }
    
    public mutating func addChunkKeyType(type: MCChunkKeyType) {
        let offset = Self.bitOffset(chunkKeyType: type)
        types.bitOn(offset: offset)
    }
    
    public mutating func deleteChunkKeyType(type: MCChunkKeyType) {
        let offset = Self.bitOffset(chunkKeyType: type)
        types.bitOff(offset: offset)
    }
}

extension MCChunkKey {
    public func checkExist(subChunkIndex: Int8) -> Bool {
        let offset = Self.bitOffset(subChunkIndex: subChunkIndex)
        return subChunks.isBitOn(offset: offset)
    }
    
    public func checkExist(chunkKeyType: MCChunkKeyType) -> Bool {
        let offset = Self.bitOffset(chunkKeyType: chunkKeyType)
        return types.isBitOn(offset: offset)
    }
    
    public func existSubChunks() -> [Int8] {
        var subChunkIndexs = [Int8]()
        let bitArray = subChunks.bitArray
        for i in 0..<bitArray.count {
            if bitArray[i] == 1 {
                let index = Self.minimumSubChunkIndex + Int8(i)
                subChunkIndexs.append(index)
            }
        }
        return subChunkIndexs
    }
    
    public func existTypes() -> Set<MCChunkKeyType> {
        var typesList = Set<MCChunkKeyType>()
        let bitArray = types.bitArray
        for i in 0..<bitArray.count {
            if bitArray[i] == 1, let newType = MCChunkKeyType(rawValue: MCChunkKeyType.keyTypeStartWith+UInt8(i)) {
                typesList.insert(newType)
            }
        }
        return typesList
    }
}
