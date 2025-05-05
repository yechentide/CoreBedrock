//
// Created by yechentide on 2025/05/05
//

extension MCBlockType {
    public static let lookup: [String: Self] = {
        var map = [String: Self]()
        for type in Self.allCases {
            map[type.rawValue] = type
        }
        return map
    }()
}
