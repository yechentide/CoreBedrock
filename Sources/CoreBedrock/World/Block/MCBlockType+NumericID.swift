//
// Created by yechentide on 2025/05/13
//

extension MCBlockType {
    private static let idLookup: [MCBlockType: Int] = {
        Dictionary(uniqueKeysWithValues: MCBlockType.allCases.enumerated().map { ($1, $0) })
    }()

    public var id: Int {
        return Self.idLookup[self]!
    }

    public static func from(id index: Int) -> MCBlockType? {
        guard 0 <= index, index < MCBlockType.allCases.count else {
            return nil
        }
        return MCBlockType.allCases[index]
    }
}
