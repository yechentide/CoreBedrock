//
// Created by yechentide on 2026/08/02
//

//
// Read-only decoders for legacy chunk 2D biome records.
//

public import Foundation

public struct LegacyBiomeColor: Sendable, Hashable {
    public let red: UInt8
    public let green: UInt8
    public let blue: UInt8
}

public struct LegacyData2D: Sendable {
    public let heightmap: [UInt16]
    public let biomeIDs: [UInt8]
    /// Present only in the oldest `0x2E` layout (RGB triples per biome entry).
    public let biomeColors: [LegacyBiomeColor]?
}

public enum LegacyData2DParser {
    private static let columnCount = 16 * 16
    private static let modernLength = columnCount * 3
    private static let oldestLength = columnCount * 6

    public static func parseData2D(_ data: Data) throws -> LegacyData2D {
        guard data.count == self.modernLength else { throw CBError.invalidDataLength(data.count) }

        return try self.parse(data, colors: false)
    }

    public static func parseLegacyData2D(_ data: Data) throws -> LegacyData2D {
        guard data.count == self.oldestLength else { throw CBError.invalidDataLength(data.count) }

        return try self.parse(data, colors: true)
    }

    private static func parse(_ data: Data, colors: Bool) throws -> LegacyData2D {
        let reader = CBBinaryReader(data: data)
        var heightmap = [UInt16]()
        heightmap.reserveCapacity(self.columnCount)
        for _ in 0..<self.columnCount {
            try heightmap.append(reader.readUInt16())
        }
        let biomeIDs = try reader.readBytes(self.columnCount)
        let biomeColors: [LegacyBiomeColor]?
        if colors {
            let rgb = try reader.readBytes(self.columnCount * 3)
            biomeColors = stride(from: 0, to: rgb.count, by: 3).map {
                .init(red: rgb[$0], green: rgb[$0 + 1], blue: rgb[$0 + 2])
            }
        } else {
            biomeColors = nil
        }
        return .init(heightmap: heightmap, biomeIDs: biomeIDs, biomeColors: biomeColors)
    }
}
