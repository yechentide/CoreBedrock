import CoreGraphics
import LvDBWrapper
import Algorithms

public struct MCChunk {
    public static let length = 16
    public static var viewSize: Int {
        length * length
    }
    public static func getRange(chunkIndex: Int32) -> ClosedRange<Int> {
        return Int(chunkIndex)*length ... Int(chunkIndex+1)*length-1
    }

    public let x: Int32
    public let z: Int32
    public let dimension: MCDimension
    private let subChunks: [MCSubChunk]

    public init(x: Int32, z: Int32, dimension: MCDimension, subChunks: [MCSubChunk]) {
        self.x = x
        self.z = z
        self.dimension = dimension
        self.subChunks = subChunks
    }

    public func getTopVisibleBlocks() -> [MCBlock] {
        var view = [MCBlock]()
        for (localX, localZ) in product(MCSubChunk.localPosRange, MCSubChunk.localPosRange) {
            let indexInView = view.count
            for subChunk in subChunks.reversed() {
                guard let blocks = subChunk.getTopDownBlocks(localX, localZ) else {
                    continue
                }
                if let topBlock = blocks.first(where: { $0.type.isOpaque }) {
                    view.append(topBlock)
                }
            }
            if indexInView == view.count {
                view.append(
                    MCBlock(type: .unknown,
                            nameTag: StringTag(name: "name", "Unknown"),
                            states: CompoundTag(), version: 0)
                )
            }
        }
        return view
    }

    private func flip(_ array: [UInt32]) -> [UInt32] {
        assert(array.count == Self.viewSize)
        var flipped = [UInt32](repeating: 0, count: Self.viewSize)
        for i in 0..<Self.viewSize {
            let x = i / Self.length
            let y = i % Self.length
            let index = y * Self.length + x
            flipped[index] = array[i]
        }
        return flipped
    }

//    public func getTopDownView() -> CGImage {
//        let argbArray = getTopVisibleBlocks().map { $0.type.argb }
//        var argbPixels = flip(argbArray)
//        let image = argbPixels.withUnsafeMutableBytes { (ptr) -> CGImage in
//            let ctx = CGContext(
//                data: ptr.baseAddress,
//                width: Self.length,
//                height: Self.length,
//                bitsPerComponent: 8,
//                bytesPerRow: 4 * Self.length,
//                space: CGColorSpace(name: CGColorSpace.sRGB)!,
//                bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue +
//                            CGImageAlphaInfo.premultipliedFirst.rawValue
//            )!
//            return ctx.makeImage()!
//        }
//        return image
//    }

//    public init(lvDB: LvDB, x: Int32, z: Int32, dimension: MCDimension) {
//        self.x = x
//        self.z = z
//        self.dimension = dimension
//        subChunks = []

//        let keyList = lvDB.getChunkKeys(x: x, z: z, dimension: dimension)
//        let keyPrefixLength = dimension == .overworld ? 8 : 12;
        // parse subChunk keys
//        keyList.forEach { key in
//            guard key.count == keyPrefixLength + 2 else { return }
//            let yIndex = Int8(truncatingIfNeeded: key[key.count-1])
//            if let subChunkData = lvDB.get(key),
//               let subChunk = MCSubChunk.parseSubChunkData(x: x, yIndex: yIndex, z: z, from: subChunkData)
//            {
//                subChunks.append(subChunk)
//            }
//        }
//        subChunks.sort { $0.yIndex < $1.yIndex }
//    }

//    private func getTopVisibleBlocks() -> [MCBlockType] {
//        let topBlocks = [MCBlockType](repeating: .air, count: Self.viewSize)
//        for subChunk in subChunks {
//            let blocks = subChunk.getTopVisibleBlocks()
//            for i in 0..<Self.viewSize {
//                if blocks[i].isOpaque {
//                    topBlocks[i] = blocks[i]
//                }
//            }
//        }
//        return topBlocks
//    }
}
