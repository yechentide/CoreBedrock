//
// Created by yechentide on 2026/08/08
//

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
