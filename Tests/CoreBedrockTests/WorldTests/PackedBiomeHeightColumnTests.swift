@testable import CoreBedrock
import Testing

struct PackedBiomeHeightColumnTests {
    @Test func heightMapUsesZMajorCoordinatesAndLittleEndianValues() {
        var heightBytes = Array(repeating: UInt8(0), count: MCChunk.viewSize * 2)
        let localX = 5
        let localZ = 9
        let correctOffset = ((localZ << 4) | localX) << 1
        let transposedOffset = ((localX << 4) | localZ) << 1
        heightBytes[correctOffset] = 0x34
        heightBytes[correctOffset + 1] = 0x12
        heightBytes[transposedOffset] = 0xCD
        heightBytes[transposedOffset + 1] = 0xAB
        let column = PackedBiomeHeightColumn(heightBytes: heightBytes, biomeSections: [])

        #expect(column.highestBlockY(atLocalX: localX, localZ: localZ) == 0x1234)
        #expect(column.highestBlockY(atLocalX: localZ, localZ: localX) == 0xABCD)
    }

    @Test func negativeYUsesFloorModuloAndDirectSectionLookup() {
        let negativeSection = PackedBiomeHeightColumn.PackedBiomeSection(
            chunkY: -1,
            bitWidth: 0,
            palette: [42],
            indicesBytes: []
        )
        let zeroSection = PackedBiomeHeightColumn.PackedBiomeSection(
            chunkY: 0,
            bitWidth: 0,
            palette: [7],
            indicesBytes: []
        )
        let column = PackedBiomeHeightColumn(
            heightBytes: Array(repeating: 0, count: MCChunk.viewSize * 2),
            biomeSections: [zeroSection, negativeSection]
        )

        #expect(column.biomeValue(atLocalX: 0, y: -1, localZ: 0) == 42)
        #expect(column.biomeValue(atLocalX: 15, y: -16, localZ: 15) == 42)
        #expect(column.biomeValue(atLocalX: 0, y: 0, localZ: 0) == 7)
        #expect(column.biomeValue(atLocalX: -1, y: -1, localZ: 0) == nil)
    }
}
