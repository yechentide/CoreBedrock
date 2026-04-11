//
// Created by yechentide on 2025/11/21
//

import LvDBWrapper

public typealias DimensionTransferEvent = CBOperationEvent<DimensionTransferProgress, Never, Never, Never>

public struct DimensionTransferProgress: Sendable {
    public let scannedChunkCount: Int
    public let processedChunkCount: Int
    public let scannedKeyCount: UInt64
    public let processedKeyCount: UInt64

    public init() {
        self.scannedChunkCount = 0
        self.processedChunkCount = 0
        self.scannedKeyCount = 0
        self.processedKeyCount = 0
    }

    public init(
        scannedChunkCount: Int,
        processedChunkCount: Int,
        scannedKeyCount: UInt64,
        processedKeyCount: UInt64
    ) {
        self.scannedChunkCount = scannedChunkCount
        self.processedChunkCount = processedChunkCount
        self.scannedKeyCount = scannedKeyCount
        self.processedKeyCount = processedKeyCount
    }
}

private struct DimensionTransferCoordKey: Hashable {
    let x: Int32
    let z: Int32
}

private struct DimensionTransferStatistics {
    // Per-phase sets deduplicate coords within a single scan pass.
    // Cumulative counters accumulate across phases (override: delete then copy).
    private var phaseSeenChunkCoords: Set<DimensionTransferCoordKey> = []
    private var phaseProcessedChunkCoords: Set<DimensionTransferCoordKey> = []
    private var cumulativeScannedChunkCount = 0
    private var cumulativeProcessedChunkCount = 0
    var scannedKeyCount: UInt64 = 0
    var processedKeyCount: UInt64 = 0

    var scannedChunkCount: Int {
        self.cumulativeScannedChunkCount
    }

    var processedChunkCount: Int {
        self.cumulativeProcessedChunkCount
    }

    mutating func markSeen(_ coord: DimensionTransferCoordKey) {
        if self.phaseSeenChunkCoords.insert(coord).inserted {
            self.cumulativeScannedChunkCount += 1
        }
    }

    mutating func markProcessed(_ coord: DimensionTransferCoordKey) {
        if self.phaseProcessedChunkCoords.insert(coord).inserted {
            self.cumulativeProcessedChunkCount += 1
        }
    }

    /// Call between phases in override mode so the same coord can be counted again.
    mutating func resetPhase() {
        self.phaseSeenChunkCoords = []
        self.phaseProcessedChunkCoords = []
    }
}

public enum DimensionTransfer {
    /// Transfer mode for dimension data
    public enum TransferMode: CaseIterable, Sendable {
        /// Delete all target keys for dimension, then write all source keys
        case override
        /// Copy only keys that do not exist in target
        case skipExisting
        /// Put each key (overwrite or add)
        case replacePerKey
    }

    private static let batchThreshold = 512

    /// Transfers dimension data with progress reporting via AsyncThrowingStream.
    public static func transfer(
        from source: any LevelKeyValueStore,
        to target: any LevelKeyValueStore,
        dimension: MCDimension,
        mode: TransferMode
    ) -> AsyncThrowingStream<DimensionTransferEvent, any Error> {
        AsyncThrowingStream(DimensionTransferEvent.self) { continuation in
            let task = Task {
                do {
                    continuation.yield(DimensionTransferEvent.progress(.init()))
                    try self.transferWithProgress(
                        from: source, to: target, dimension: dimension, mode: mode
                    ) { event in
                        continuation.yield(event)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    // MARK: - Private progress-reporting workers

    private static func transferWithProgress(
        from source: any LevelKeyValueStore,
        to target: any LevelKeyValueStore,
        dimension: MCDimension,
        mode: TransferMode,
        reportEvent: @escaping @Sendable (DimensionTransferEvent) -> Void
    ) throws {
        var statistics = DimensionTransferStatistics()
        switch mode {
        case .override:
            try self.deleteTargetDimensionKeys(
                target: target, dimension: dimension, statistics: &statistics, reportEvent: reportEvent
            )
            statistics.resetPhase()
            try self.copyKeys(
                from: source, to: target, dimension: dimension, mode: .replacePerKey,
                statistics: &statistics, reportEvent: reportEvent
            )
        case .skipExisting:
            try self.copyKeys(
                from: source, to: target, dimension: dimension, mode: .skipExisting,
                statistics: &statistics, reportEvent: reportEvent
            )
        case .replacePerKey:
            try self.copyKeys(
                from: source, to: target, dimension: dimension, mode: .replacePerKey,
                statistics: &statistics, reportEvent: reportEvent
            )
        }
        Self.emit(statistics: statistics, reportEvent: reportEvent)
    }

    private static func deleteTargetDimensionKeys(
        target: any LevelKeyValueStore,
        dimension: MCDimension,
        statistics: inout DimensionTransferStatistics,
        reportEvent: (@Sendable (DimensionTransferEvent) -> Void)?
    ) throws {
        let iter = try target.makeIterator()
        defer { iter.close() }

        let batch = LvDBWriteBatch()
        var batchCount = 0

        iter.moveToFirst()
        while iter.isValid {
            try Task.checkCancellation()
            defer { iter.moveToNext() }

            guard let keyData = iter.currentKey else {
                continue
            }

            try autoreleasepool {
                let parsedKey = LvDBKey.parse(data: keyData)
                if case let .subChunk(chunkX, chunkZ, dim, _, _) = parsedKey, dim == dimension {
                    let coord = DimensionTransferCoordKey(x: chunkX, z: chunkZ)
                    statistics.markSeen(coord)
                    statistics.scannedKeyCount += 1
                    batch.remove(keyData)
                    statistics.markProcessed(coord)
                    statistics.processedKeyCount += 1
                    batchCount += 1

                    if batchCount >= self.batchThreshold {
                        try Task.checkCancellation()
                        try target.writeBatch(batch)
                        batch.clear()
                        batchCount = 0
                    }

                    if let reportEvent, Self.shouldEmitProgress(for: statistics.scannedKeyCount) {
                        Self.emit(statistics: statistics, reportEvent: reportEvent)
                    }
                }
            }
        }

        if batchCount > 0 {
            try Task.checkCancellation()
            try autoreleasepool {
                try target.writeBatch(batch)
                batch.clear()
            }
        }
    }

    // swiftlint:disable function_parameter_count
    private static func copyKeys(
        from source: any LevelKeyValueStore,
        to target: any LevelKeyValueStore,
        dimension: MCDimension,
        mode: TransferMode,
        statistics: inout DimensionTransferStatistics,
        reportEvent: (@Sendable (DimensionTransferEvent) -> Void)?
    ) throws {
        let iter = try source.makeIterator()
        defer { iter.close() }

        let batch = LvDBWriteBatch()
        var batchCount = 0

        iter.moveToFirst()
        while iter.isValid {
            try Task.checkCancellation()
            defer { iter.moveToNext() }

            guard let keyData = iter.currentKey,
                  let valueData = iter.currentValue else {
                continue
            }

            try autoreleasepool {
                let parsedKey = LvDBKey.parse(data: keyData)
                if case let .subChunk(chunkX, chunkZ, dim, _, _) = parsedKey, dim == dimension {
                    let coord = DimensionTransferCoordKey(x: chunkX, z: chunkZ)
                    statistics.markSeen(coord)
                    statistics.scannedKeyCount += 1

                    let shouldWrite: Bool = switch mode {
                    case .skipExisting: !target.containsKey(keyData)
                    case .replacePerKey, .override: true
                    }

                    if shouldWrite {
                        batch.put(keyData, value: valueData)
                        statistics.markProcessed(coord)
                        statistics.processedKeyCount += 1
                        batchCount += 1

                        if batchCount >= self.batchThreshold {
                            try Task.checkCancellation()
                            try target.writeBatch(batch)
                            batch.clear()
                            batchCount = 0
                        }
                    }

                    if let reportEvent, Self.shouldEmitProgress(for: statistics.scannedKeyCount) {
                        Self.emit(statistics: statistics, reportEvent: reportEvent)
                    }
                }
            }
        }

        if batchCount > 0 {
            try Task.checkCancellation()
            try autoreleasepool {
                try target.writeBatch(batch)
                batch.clear()
            }
        }
    }

    // swiftlint:enable function_parameter_count

    // MARK: - Helpers

    private static func shouldEmitProgress(for count: UInt64) -> Bool {
        count == 1 || count.isMultiple(of: 512)
    }

    private static func emit(
        statistics: DimensionTransferStatistics,
        reportEvent: (DimensionTransferEvent) -> Void
    ) {
        let progress = DimensionTransferProgress(
            scannedChunkCount: statistics.scannedChunkCount,
            processedChunkCount: statistics.processedChunkCount,
            scannedKeyCount: statistics.scannedKeyCount,
            processedKeyCount: statistics.processedKeyCount
        )
        reportEvent(DimensionTransferEvent.progress(progress))
    }
}
