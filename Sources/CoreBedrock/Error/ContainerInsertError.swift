//
// Created by yechentide on 2026/02/06
//

import Foundation

public enum ContainerInsertError: Error, LocalizedError, Sendable, Hashable {
    case invalidPlayerNBT
    case noAvailableSlot
}
