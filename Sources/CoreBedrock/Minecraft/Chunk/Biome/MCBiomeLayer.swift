import Foundation

public class MCBiomeLayer {
    var palettes: [MCBiomeType]
    var map: [UInt16]

    public init() {
        palettes = [MCBiomeType]()
        map = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
    }

    public init(palettes: [MCBiomeType], map: [UInt16]) {
        self.palettes = palettes
        self.map = map
    }

    public init(singlePalette: MCBiomeType) {
        palettes = [singlePalette]
        map = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
    }
}
