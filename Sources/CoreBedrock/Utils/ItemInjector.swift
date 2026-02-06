//
// Created by yechentide on 2026/02/06
//

import Foundation

public enum ItemInjector {
    public static func giveItemToPlayer(
        item: CompoundTag, playerKey: Data, in world: LevelKeyValueStore
    ) throws {
        let playerTag = try loadPlayerTag(from: world, key: playerKey)
        let inventory = try loadPlayerInventory(from: playerTag)

        guard let slotIndex = firstAvailableSlot(in: inventory) else {
            throw ContainerInsertError.noAvailableSlot
        }

        try self.place(item: item, into: inventory, at: slotIndex)

        let newData = try playerTag.toData()
        try world.putData(newData, forKey: playerKey)
    }

    private static func loadPlayerTag(
        from world: LevelKeyValueStore,
        key: Data
    ) throws -> CompoundTag {
        let data = try world.data(forKey: key)
        let reader = CBTagReader(data: data)

        guard let tag = try reader.readNext() as? CompoundTag else {
            throw ContainerInsertError.invalidPlayerNBT
        }

        return tag
    }

    private static func loadPlayerInventory(
        from playerTag: CompoundTag
    ) throws -> ListTag {
        guard let inventory = playerTag["Inventory"] as? ListTag else {
            throw ContainerInsertError.invalidPlayerNBT
        }

        return inventory
    }

    private static func firstAvailableSlot(
        in inventory: ListTag
    ) -> Int? {
        inventory.tags.firstIndex { slotTag in
            slotTag["Count"]?.stringValue == "0"
        }
    }

    private static func place(
        item: CompoundTag,
        into inventory: ListTag,
        at index: Int
    ) throws {
        _ = item.remove(forKey: "Slot")
        try item.append(ByteTag(name: "Slot", UInt8(index)))
        inventory.tags[index].parent = nil
        inventory.tags[index] = item
    }
}
