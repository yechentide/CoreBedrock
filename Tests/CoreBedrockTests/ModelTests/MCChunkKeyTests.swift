import XCTest
@testable import CoreBedrock

final class MCChunkKeyTests: XCTestCase {
    private let defaultKey = MCChunkKey(xIndex: 0,
                         zIndex: 0,
                         types: UInt32(0b00000000_00000000_00000000_00000000),
                         subChunks: UInt32(0b00000000_00000000_00000000_00000000))
    
    func testBitOffsetForSubChunk() {
        for subChunkIndex in -4...19 {
            let result = MCChunkKey.bitOffset(subChunkIndex: Int8(subChunkIndex))
            let expected = UInt8(subChunkIndex + 4)
            XCTAssertEqual(expected, result)
        }
    }
    
    func testBitOffsetForKeyType() {
        for keyType in MCChunkKeyType.allCases {
            if keyType == .legacyChunkVersion { continue }
            
            let result = MCChunkKey.bitOffset(chunkKeyType: keyType)
            let expected = keyType.rawValue - MCChunkKeyType.keyTypeStartWith
            XCTAssertEqual(expected, result)
        }
    }
    
    func testAddDeleteShunChunks() {
        var key = defaultKey
        key.addSubChunk(index: -2)
        key.addSubChunk(index: -1)
        key.addSubChunk(index: 0)
        key.addSubChunk(index: 1)
        key.addSubChunk(index: 2)
        key.addSubChunk(index: 19)
        print(key.subChunks.binaryString)
        XCTAssertEqual(key.subChunks, UInt32(0b00000000_10000000_00000000_01111100))
        key.deleteSubChunk(index: -2)
        key.deleteSubChunk(index: 19)
        print(key.subChunks.binaryString)
        XCTAssertEqual(key.subChunks, UInt32(0b00000000_00000000_00000000_01111000))
    }
    
    func testAddDeleteKeyTypes() {
        var key = defaultKey
        key.addChunkKeyType(type: .subChunkPrefix)
        key.addChunkKeyType(type: .biomeState)
        XCTAssertEqual(key.types, UInt32(0b00000000_00000000_00000100_00010000))
        key.deleteChunkKeyType(type: .biomeState)
        XCTAssertEqual(key.types, UInt32(0b00000000_00000000_00000000_00010000))
    }
    
    func testSubChunkExist() {
        let key = MCChunkKey(xIndex: 0, zIndex: 0, subChunks: UInt32(0b00000000_10000000_00000000_01111100))
        XCTAssertEqual(false, key.checkExist(subChunkIndex: -4))
        XCTAssertEqual(true, key.checkExist(subChunkIndex: -2))
        XCTAssertEqual(true, key.checkExist(subChunkIndex: 0))
        XCTAssertEqual(true, key.checkExist(subChunkIndex: 1))
        XCTAssertEqual(true, key.checkExist(subChunkIndex: 19))
    }
    
    func testKeyTypeExist() {
        let key = MCChunkKey(xIndex: 0, zIndex: 0, types: UInt32(0b00000000_00000000_00000100_00010000))
        XCTAssertEqual(false, key.checkExist(chunkKeyType: .data3D))
        XCTAssertEqual(true, key.checkExist(chunkKeyType: .subChunkPrefix))
        XCTAssertEqual(true, key.checkExist(chunkKeyType: .biomeState))
    }
    
    func testSubChunkArray() {
        let key = MCChunkKey(xIndex: 0, zIndex: 0, subChunks: UInt32(0b00000000_10000000_00000000_01111100))
        let array = key.existSubChunks()
        XCTAssertEqual(array,
                       [Int8](arrayLiteral: -2, -1, 0, 1, 2, 19))
    }
    
    func testKeyTypeSet() {
        let key = MCChunkKey(xIndex: 0, zIndex: 0, types: UInt32(0b00000000_00000000_00000100_00010000))
        let set = key.existTypes()
        XCTAssertEqual(2, set.count)
        XCTAssertEqual(true, set.contains(.subChunkPrefix))
        XCTAssertEqual(true, set.contains(.biomeState))
    }
    
    func testGenerateKeyData() {
        let key = MCChunkKey(xIndex: 0, zIndex: 0,
                             types: UInt32(0b00000000_00000000_00000100_00010000),
                             subChunks: UInt32(0b00000000_00000000_00000000_00111000))
        let result = key.generateKeyData(dimension: .overworld)
        let expected: [Data] = [
            Data([
                0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x35]),
            Data([
                0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x2F, 0xFF]),
            Data([
                0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x2F, 0x00]),
            Data([
                0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x2F, 0x01])
        ]
        XCTAssertEqual(expected, result)
    }
}
