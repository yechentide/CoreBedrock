//
// Created by yechentide on 2025/04/20
//

import LvDBWrapper

extension LvDB {
    public func enumerateActorKeys(
        digpData: Data,
        handler: @escaping (Int, Data) -> Void
    ) -> Bool {
        guard digpData.count % 8 == 0 else {
            return false
        }

        let num = digpData.count / 8
        for i in 0..<num {
            if Task.isCancelled {
                return false
            }

            let startIndex = digpData.startIndex + i * 8
            let endIndex = startIndex + 8
            let key = digpData.subdata(in: startIndex..<endIndex)
            handler(i, key)
        }
        return true
    }
}
