import Foundation

public protocol MCArea {
    var xIndex: Int32 { get }
    var zIndex: Int32 { get }
    static var length: Int32 { get }
}

extension MCArea {
    public var startXPos: Int32 { Self.calcPos(index: xIndex, lowerBound: true) }
    public var endXPos:   Int32 { Self.calcPos(index: xIndex, lowerBound: false) }
    public var startZPos: Int32 { Self.calcPos(index: zIndex, lowerBound: true) }
    public var endZPos:   Int32 { Self.calcPos(index: zIndex, lowerBound: false) }
    public var xPosRange: ClosedRange<Int32> { startXPos...endXPos }
    public var zPosRange: ClosedRange<Int32> { startZPos...endZPos }
    
    public static func calcPos(index: Int32, lowerBound: Bool = true) -> Int32 {
        return lowerBound ? index*Self.length : (index+1)*Self.length-1
    }

    public static func calcIndex(pos: Int32) -> Int32 {
        let result = floor(Double(pos) / Double(Self.length))
        return Int32(result)
    }

    public static func caleIndex(xPos: Int32, zPos: Int32) -> (x: Int32, z: Int32) {
        let x = Self.calcIndex(pos: xPos)
        let z = Self.calcIndex(pos: zPos)
        return (x, z)
    }

    public static func caleIndex(xPos: Int32, yPos: Int32, zPos: Int32) -> (x: Int32, y: Int32, z: Int32) {
        let x = Self.calcIndex(pos: xPos)
        let y = Self.calcIndex(pos: yPos)
        let z = Self.calcIndex(pos: zPos)
        return (x, y, z)
    }
}
