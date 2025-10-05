//
// Created by yechentide on 2025/09/19
//

import Foundation

internal struct BlockAttributeJSON<T: Codable & Hashable & Equatable>: Codable {
    let version: Int
    let entries: [BlockAttributeEntryJSON<T>]
}

internal struct BlockAttributeEntryJSON<T: Codable & Hashable & Equatable>: Codable {
    let id: String
    let defaultValue: T
    let overrides: [BlockAttributeOverrideJSON<T>]

    enum CodingKeys: String, CodingKey {
        case id, defaultValue, overrides
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        defaultValue = try container.decode(T.self, forKey: .defaultValue)
        overrides = try container.decodeIfPresent([BlockAttributeOverrideJSON<T>].self, forKey: .overrides) ?? []
    }
}

internal struct BlockAttributeOverrideJSON<T: Codable & Hashable & Equatable>: Codable {
    let condition: BlockStateCondition
    let value: T
}

internal typealias BlockStateCondition = [String:String]
