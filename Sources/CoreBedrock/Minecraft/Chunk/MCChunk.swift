import CoreGraphics
import LvDBWrapper

public struct MCChunk {
    public static var viewSize: Int {
        MCSubChunk.length * MCSubChunk.length
    }

    public let x: Int32
    public let z: Int32
    public let dimension: MCDimension
    private var subChunks: [MCSubChunk]

    public init(lvDB: LvDB, x: Int32, z: Int32, dimension: MCDimension) {
        self.x = x
        self.z = z
        self.dimension = dimension
        subChunks = []

        let keyList = lvDB.getChunkKeys(x: x, z: z, dimension: dimension)
        let keyPrefixLength = dimension == .overworld ? 8 : 12;
        // parse subChunk keys
        keyList.forEach { key in
            guard key.count == keyPrefixLength + 2 else { return }
            let yIndex = Int8(truncatingIfNeeded: key[key.count-1])
            if let subChunkData = lvDB.get(key),
               let subChunk = MCSubChunk.parseSubChunkData(x: x, yIndex: yIndex, z: z, from: subChunkData)
            {
                subChunks.append(subChunk)
            }
        }
        subChunks.sort { $0.yIndex < $1.yIndex }
    }

    private func getTopVisibleBlocks() -> [MCBlock] {
        var topBlocks = [MCBlock](repeating: .air, count: Self.viewSize)
        for subChunk in subChunks {
            let blocks = subChunk.getTopVisibleBlocks()
            for i in 0..<Self.viewSize {
                if blocks[i].isOpaque {
                    topBlocks[i] = blocks[i]
                }
            }
        }
        return topBlocks
    }

    private func flip(_ array: [UInt32]) -> [UInt32] {
        assert(array.count == Self.viewSize)
        var flipped = [UInt32](repeating: 0, count: Self.viewSize)
        for i in 0..<Self.viewSize {
            let x = i / MCSubChunk.length
            let y = i % MCSubChunk.length
            let index = y * MCSubChunk.length + x
            flipped[index] = array[i]
        }
        return flipped
    }

    public func getTopDownView() -> CGImage {
        let view = getTopVisibleBlocks().map { $0.color }
        var rgbaPixels = flip(view)
        let image = rgbaPixels.withUnsafeMutableBytes { (ptr) -> CGImage in
            let ctx = CGContext(
                data: ptr.baseAddress,
                width: MCSubChunk.length,
                height: MCSubChunk.length,
                bitsPerComponent: 8,
                bytesPerRow: 4 * MCSubChunk.length,
                space: CGColorSpace(name: CGColorSpace.sRGB)!,
                bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue +
                            CGImageAlphaInfo.premultipliedFirst.rawValue
            )!
            return ctx.makeImage()!
        }
        return image
    }
}
