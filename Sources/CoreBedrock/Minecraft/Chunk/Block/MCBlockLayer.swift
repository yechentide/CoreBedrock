import Foundation

public class MCBlockLayer {
    var palettes: [MCBlock]
    var map: [UInt16]

    public init() {
        palettes = [MCBlock]()
        map = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
    }

    public init(palettes: [MCBlock], map: [UInt16]) {
        self.palettes = palettes
        self.map = map
    }

    public init(palette: MCBlock) {
        palettes = [palette]
        map = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
    }
}
