//
// Created by yechentide on 2024/10/04
//

public struct Pos3D<T: SignedInteger>: Equatable, Hashable {
    public let x: T
    public let y: T
    public let z: T

    public init(x: T, y: T, z: T) {
        self.x = x
        self.y = y
        self.z = z
    }

    static func distansSquare(p1: Pos3D<T>, p2: Pos3D<T>) -> T {
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        let dz = p1.z - p2.z
        return dx * dx + dy * dy + dz * dz
    }
}

public typealias Pos3Di32 = Pos3D<Int32>
