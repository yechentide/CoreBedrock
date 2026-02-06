//
// Created by yechentide on 2026/02/06
//

import Foundation

public enum ContainerInsertError: Error, Equatable, LocalizedError {
    case invalidPlayerNBT
    case noAvailableSlot
}
