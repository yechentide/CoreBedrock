//
// Created by yechentide on 2025/04/20
//

import Foundation

public typealias ChunkDeletionEvent = CBOperationEvent<ChunkDeletionProgress, Never, Never, Never>

public struct ChunkDeletionProgress: Sendable {
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

private struct ChunkCoordKey: Hashable {
    let x: Int32
    let z: Int32
}

private struct ChunkDeletionStatistics {
    var seenChunkCoords: Set<ChunkCoordKey> = []
    var processedChunkCoords: Set<ChunkCoordKey> = []
    var scannedKeyCount: UInt64 = 0
    var processedKeyCount: UInt64 = 0

    var scannedChunkCount: Int {
        self.seenChunkCoords.count
    }

    var processedChunkCount: Int {
        self.processedChunkCoords.count
    }
}

public extension KeyValueStore {
    // MARK: - deleteAllChunks

    func deleteAllChunks(in dimension: MCDimension) -> AsyncThrowingStream<ChunkDeletionEvent, any Error> {
        let (stream, continuation) = AsyncThrowingStream<ChunkDeletionEvent, any Error>.makeStream()
        let store = self
        let task = Task {
            do {
                continuation.yield(ChunkDeletionEvent.progress(.init()))
                try store.deleteAllChunks(in: dimension) { event in
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
        return stream
    }

    // swiftlint:disable function_body_length
    private func deleteAllChunks(
        in dimension: MCDimension, reportEvent: @escaping @Sendable (ChunkDeletionEvent) -> Void
    ) throws {
        var statistics = ChunkDeletionStatistics()
        let batch = LevelDBWriteBatch()

        let iter = try self.makeIterator()
        defer {
            iter.close()
        }

        iter.moveToFirst()
        while iter.isValid {
            try Task.checkCancellation()
            defer {
                iter.moveToNext()
            }
            guard let key = iter.currentKey else {
                break
            }

            statistics.scannedKeyCount += 1

            try autoreleasepool { [batch, iter] in
                let lvdbKey = LvDBKey.parse(data: key)
                if case let LvDBKey.subChunk(chunkX, chunkZ, d, _, _) = lvdbKey, d == dimension {
                    let coord = ChunkCoordKey(x: chunkX, z: chunkZ)
                    batch.remove(key)
                    statistics.seenChunkCoords.insert(coord)
                    statistics.processedChunkCoords.insert(coord)
                    statistics.processedKeyCount += 1
                }
                if case let LvDBKey.digp(chunkX, chunkZ, d) = lvdbKey, d == dimension {
                    let coord = ChunkCoordKey(x: chunkX, z: chunkZ)
                    batch.remove(key)
                    statistics.seenChunkCoords.insert(coord)
                    statistics.processedChunkCoords.insert(coord)
                    statistics.processedKeyCount += 1
                    if let digpData = iter.currentValue, !digpData.isEmpty, digpData.count % 8 == 0 {
                        for i in 0..<digpData.count / 8 {
                            try Task.checkCancellation()
                            let actorprefixKey = Data("actorprefix".utf8) + digpData[i * 8...i * 8 + 7]
                            batch.remove(actorprefixKey)
                            statistics.processedKeyCount += 1
                        }
                    }
                }
            }

            try Task.checkCancellation()
            try autoreleasepool {
                if batch.approximateSize() > 20000 {
                    try self.writeBatch(batch)
                    batch.clear()
                }
            }

            if self.shouldEmitChunkDeletionProgress(for: statistics.scannedKeyCount) {
                self.emit(statistics: statistics, reportEvent: reportEvent)
            }
        }
        if batch.approximateSize() > 0 {
            try self.writeBatch(batch)
            batch.clear()
        }

        self.emit(statistics: statistics, reportEvent: reportEvent)
    }

    // swiftlint:enable function_body_length

    // MARK: - deleteChunksWithinRange

    func deleteChunksWithinRange(
        in dimension: MCDimension,
        fromChunkX startX: Int32, fromChunkZ startZ: Int32,
        toChunkX endX: Int32, toChunkZ endZ: Int32
    ) -> AsyncThrowingStream<ChunkDeletionEvent, any Error> {
        let (stream, continuation) = AsyncThrowingStream<ChunkDeletionEvent, any Error>.makeStream()
        let store = self
        let task = Task {
            do {
                continuation.yield(ChunkDeletionEvent.progress(.init()))
                try store.deleteChunksWithinRange(
                    in: dimension,
                    fromChunkX: startX, fromChunkZ: startZ,
                    toChunkX: endX, toChunkZ: endZ
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
        return stream
    }

    // swiftlint:disable function_parameter_count
    private func deleteChunksWithinRange(
        in dimension: MCDimension,
        fromChunkX startX: Int32, fromChunkZ startZ: Int32,
        toChunkX endX: Int32, toChunkZ endZ: Int32,
        reportEvent: @escaping @Sendable (ChunkDeletionEvent) -> Void
    ) throws {
        var statistics = ChunkDeletionStatistics()
        let xRange = min(startX, endX)...max(startX, endX)
        let zRange = min(startZ, endZ)...max(startZ, endZ)
        let batch = LevelDBWriteBatch()

        for x in xRange {
            try Task.checkCancellation()
            for z in zRange {
                let coord = ChunkCoordKey(x: x, z: z)
                statistics.seenChunkCoords.insert(coord)

                let prefix = LvDBKeyFactory.makeBaseChunkKey(x: x, z: z, dimension: dimension)
                let counts = autoreleasepool { () -> (scanned: UInt64, processed: UInt64) in
                    let chunkCounts = self.removeChunkKeys(keyPrefix: prefix, batch: batch)
                    let actorCounts = self.removeActorAndDigpKeys(keyPrefix: prefix, batch: batch)
                    return (chunkCounts.scanned + actorCounts.scanned, chunkCounts.processed + actorCounts.processed)
                }
                statistics.scannedKeyCount += counts.scanned
                statistics.processedKeyCount += counts.processed
                if counts.scanned > 0 {
                    statistics.processedChunkCoords.insert(coord)
                }

                if batch.approximateSize() > 20000 {
                    try Task.checkCancellation()
                    try self.writeBatch(batch)
                    batch.clear()
                }

                if self.shouldEmitChunkDeletionProgress(for: UInt64(statistics.scannedKeyCount)) {
                    self.emit(statistics: statistics, reportEvent: reportEvent)
                }
            }
            try Task.checkCancellation()
            try self.writeBatch(batch)
            batch.clear()
        }

        self.emit(statistics: statistics, reportEvent: reportEvent)
    }

    // swiftlint:enable function_parameter_count

    // MARK: - deleteChunksOutsideRange

    func deleteChunksOutsideRange(
        in dimension: MCDimension,
        fromChunkX startX: Int32, fromChunkZ startZ: Int32,
        toChunkX endX: Int32, toChunkZ endZ: Int32
    ) -> AsyncThrowingStream<ChunkDeletionEvent, any Error> {
        let (stream, continuation) = AsyncThrowingStream<ChunkDeletionEvent, any Error>.makeStream()
        let store = self
        let task = Task {
            do {
                continuation.yield(ChunkDeletionEvent.progress(.init()))
                try store.deleteChunksOutsideRange(
                    in: dimension,
                    fromChunkX: startX, fromChunkZ: startZ,
                    toChunkX: endX, toChunkZ: endZ
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
        return stream
    }

    // swiftlint:disable function_body_length function_parameter_count
    private func deleteChunksOutsideRange(
        in dimension: MCDimension,
        fromChunkX startX: Int32, fromChunkZ startZ: Int32,
        toChunkX endX: Int32, toChunkZ endZ: Int32,
        reportEvent: @escaping @Sendable (ChunkDeletionEvent) -> Void
    ) throws {
        var statistics = ChunkDeletionStatistics()
        let xRange = min(startX, endX)...max(startX, endX)
        let zRange = min(startZ, endZ)...max(startZ, endZ)
        let iter = try self.makeIterator()
        let batch = LevelDBWriteBatch()
        defer { iter.close() }

        iter.moveToFirst()
        while iter.isValid {
            try Task.checkCancellation()
            defer { iter.moveToNext() }
            guard let key = iter.currentKey else { break }

            statistics.scannedKeyCount += 1

            let lvdbKey = LvDBKey.parse(data: key)
            if case let LvDBKey.subChunk(cx, cz, d, _, _) = lvdbKey,
               d == dimension, !xRange.contains(cx) || !zRange.contains(cz) {
                let coord = ChunkCoordKey(x: cx, z: cz)
                batch.remove(key)
                statistics.seenChunkCoords.insert(coord)
                statistics.processedChunkCoords.insert(coord)
                statistics.processedKeyCount += 1
            }
            if case let LvDBKey.digp(cx, cz, d) = lvdbKey,
               d == dimension, !xRange.contains(cx) || !zRange.contains(cz) {
                let coord = ChunkCoordKey(x: cx, z: cz)
                batch.remove(key)
                statistics.seenChunkCoords.insert(coord)
                statistics.processedChunkCoords.insert(coord)
                statistics.processedKeyCount += 1
                if let digpData = iter.currentValue, !digpData.isEmpty, digpData.count % 8 == 0 {
                    for i in 0..<digpData.count / 8 {
                        try Task.checkCancellation()
                        let actorprefixKey = Data("actorprefix".utf8) + digpData[i * 8...i * 8 + 7]
                        batch.remove(actorprefixKey)
                        statistics.processedKeyCount += 1
                    }
                }
            }

            try Task.checkCancellation()
            if batch.approximateSize() > 20000 {
                try self.writeBatch(batch)
                batch.clear()
            }

            if self.shouldEmitChunkDeletionProgress(for: statistics.scannedKeyCount) {
                self.emit(statistics: statistics, reportEvent: reportEvent)
            }
        }
        if batch.approximateSize() > 0 {
            try self.writeBatch(batch)
            batch.clear()
        }

        self.emit(statistics: statistics, reportEvent: reportEvent)
    }

    // swiftlint:enable function_body_length function_parameter_count

    // MARK: - Helpers

    @discardableResult
    private func removeChunkKeys(
        keyPrefix: Data, batch: any KeyValueWriteBatch
    ) -> (scanned: UInt64, processed: UInt64) {
        var scanned: UInt64 = 0
        var processed: UInt64 = 0
        for yIndex in Int8(-4)...Int8(20) {
            let key = keyPrefix + LvDBChunkKeyType.subChunkPrefix.rawValue.data + yIndex.data
            if containsKey(key) { scanned += 1 }
            batch.remove(key)
            processed += 1
        }
        for chunkKeyType in LvDBChunkKeyType.allCases {
            guard chunkKeyType != .subChunkPrefix else { continue }

            let key = keyPrefix + chunkKeyType.rawValue.data
            if containsKey(key) { scanned += 1 }
            batch.remove(key)
            processed += 1
        }
        return (scanned, processed)
    }

    @discardableResult
    private func removeActorAndDigpKeys(
        keyPrefix: Data, batch: any KeyValueWriteBatch
    ) -> (scanned: UInt64, processed: UInt64) {
        let digpKey = Data("digp".utf8) + keyPrefix

        guard let digpData = try? data(forKey: digpKey), !digpData.isEmpty, digpData.count % 8 == 0 else {
            return (0, 0)
        }

        var scanned: UInt64 = 1 // digp key itself
        var processed: UInt64 = 1 // digp key itself
        for i in 0..<digpData.count / 8 {
            let actorprefixKey = Data("actorprefix".utf8) + digpData[i * 8...i * 8 + 7]
            batch.remove(actorprefixKey)
            scanned += 1
            processed += 1
        }
        batch.remove(digpKey)
        return (scanned: scanned, processed: processed)
    }

    private func shouldEmitChunkDeletionProgress(for count: UInt64) -> Bool {
        count == 1 || count.isMultiple(of: 512)
    }

    private func emit(statistics: ChunkDeletionStatistics, reportEvent: (ChunkDeletionEvent) -> Void) {
        let progress = ChunkDeletionProgress(
            scannedChunkCount: statistics.scannedChunkCount,
            processedChunkCount: statistics.processedChunkCount,
            scannedKeyCount: statistics.scannedKeyCount,
            processedKeyCount: statistics.processedKeyCount
        )
        reportEvent(ChunkDeletionEvent.progress(progress))
    }
}
