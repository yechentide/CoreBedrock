public struct Pos2D<T: SignedInteger>: Equatable, Hashable {
    public let x: T
    public let z: T

    static func distansSquare(p1: Pos2D<T>, p2: Pos2D<T>) -> T {
        let dx = p1.x - p2.x
        let dz = p1.z - p2.z
        return dx * dx + dz * dz
    }
}

typealias Pos2Di32 = Pos2D<Int32>
