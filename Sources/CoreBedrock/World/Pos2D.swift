//
// Created by yechentide on 2024/10/04
//

public struct Pos2D<T: SignedInteger>: Equatable, Hashable {
    public let x: T
    public let z: T

    public init(x: T, z: T) {
        self.x = x
        self.z = z
    }

    static func distansSquare(p1: Pos2D<T>, p2: Pos2D<T>) -> T {
        let dx = p1.x - p2.x
        let dz = p1.z - p2.z
        return dx * dx + dz * dz
    }
}

public typealias Pos2Di32 = Pos2D<Int32>
