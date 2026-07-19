//
// Created by yechentide on 2026/07/19
//

public import Foundation
import ImageCodecC

public enum CBImageScanlineWriterError: Error, LocalizedError, Sendable, Hashable {
    case invalidDimensions
    case invalidRowData
    case encoderFailure(String)
    case writerUnavailable

    public var errorDescription: String? {
        switch self {
        case .invalidDimensions:
            "Invalid image dimensions."
        case .invalidRowData:
            "Invalid image row data."
        case let .encoderFailure(message):
            message
        case .writerUnavailable:
            "The image writer is unavailable."
        }
    }
}

/// Incrementally encodes RGBA8 scanlines into a PNG or JPEG file.
///
/// Calls are serialized internally. Rows must be supplied from top to bottom, and `finish()`
/// must be called after exactly `height` rows have been written.
public final class CBImageScanlineWriter: @unchecked Sendable {
    public struct RGBColor: Sendable, Hashable {
        public let red: UInt8
        public let green: UInt8
        public let blue: UInt8

        public init(red: UInt8, green: UInt8, blue: UInt8) {
            self.red = red
            self.green = green
            self.blue = blue
        }
    }

    public enum Format: Sendable, Hashable {
        case png
        case jpeg(quality: Int, background: RGBColor)
    }

    private var encoder: OpaquePointer?
    private let outputURL: URL
    private let width: Int
    private let lock = NSLock()
    private var finalizedBytes: Int64 = 0

    public var bytesWritten: Int64 {
        self.withLock {
            guard let encoder else { return self.finalizedBytes }

            return CBImageEncoderBytesWritten(encoder)
        }
    }

    public var isFinished: Bool {
        self.withLock { self.encoder == nil && self.finalizedBytes > 0 }
    }

    public init(outputURL: URL, width: Int, height: Int, format: Format) throws {
        guard let cWidth = Int32(exactly: width),
              let cHeight = Int32(exactly: height),
              cWidth > 0,
              cHeight > 0
        else {
            throw CBImageScanlineWriterError.invalidDimensions
        }

        self.outputURL = outputURL
        self.width = width
        var errorBuffer = [CChar](repeating: 0, count: 512)
        self.encoder = outputURL.withUnsafeFileSystemRepresentation { path in
            guard let path else { return nil }

            switch format {
            case .png:
                return CBImageEncoderCreatePNG(
                    path,
                    cWidth,
                    cHeight,
                    &errorBuffer,
                    errorBuffer.count
                )
            case let .jpeg(quality, background):
                return CBImageEncoderCreateJPEG(
                    path,
                    cWidth,
                    cHeight,
                    Int32(min(100, max(1, quality))),
                    background.red,
                    background.green,
                    background.blue,
                    &errorBuffer,
                    errorBuffer.count
                )
            }
        }
        guard self.encoder != nil else {
            try? FileManager.default.removeItem(at: outputURL)
            throw CBImageScanlineWriterError.encoderFailure(Self.message(from: errorBuffer))
        }
    }

    deinit {
        CBImageEncoderDestroy(self.encoder)
    }

    public func write(rows: Data, bytesPerRow: Int, rowCount: Int) throws {
        let (minimumBytesPerRow, rowSizeOverflow) = self.width.multipliedReportingOverflow(by: 4)
        let (requiredBytes, dataSizeOverflow) = bytesPerRow.multipliedReportingOverflow(by: rowCount)
        guard !rowSizeOverflow,
              !dataSizeOverflow,
              Int32(exactly: rowCount) != nil,
              rowCount >= 0,
              bytesPerRow >= minimumBytesPerRow,
              requiredBytes <= rows.count
        else {
            throw CBImageScanlineWriterError.invalidRowData
        }
        guard rowCount > 0 else { return }

        try self.withLock {
            guard let encoder else {
                throw CBImageScanlineWriterError.writerUnavailable
            }

            var errorBuffer = [CChar](repeating: 0, count: 512)
            let succeeded = rows.withUnsafeBytes { bytes in
                guard let baseAddress = bytes.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return false
                }

                return CBImageEncoderWriteRows(
                    encoder,
                    baseAddress,
                    rows.count,
                    bytesPerRow,
                    Int32(rowCount),
                    &errorBuffer,
                    errorBuffer.count
                )
            }
            guard succeeded else {
                throw CBImageScanlineWriterError.encoderFailure(Self.message(from: errorBuffer))
            }
        }
    }

    public func finish() throws {
        try self.withLock {
            guard let encoder else {
                throw CBImageScanlineWriterError.writerUnavailable
            }

            var errorBuffer = [CChar](repeating: 0, count: 512)
            guard CBImageEncoderFinish(encoder, &errorBuffer, errorBuffer.count) else {
                throw CBImageScanlineWriterError.encoderFailure(Self.message(from: errorBuffer))
            }

            self.finalizedBytes = CBImageEncoderBytesWritten(encoder)
            CBImageEncoderDestroy(encoder)
            self.encoder = nil
        }
    }

    public func cancel() {
        self.withLock {
            guard self.encoder != nil else { return }

            CBImageEncoderDestroy(self.encoder)
            self.encoder = nil
            try? FileManager.default.removeItem(at: self.outputURL)
        }
    }

    private static func message(from buffer: [CChar]) -> String {
        buffer.withUnsafeBufferPointer { pointer in
            guard let baseAddress = pointer.baseAddress, baseAddress.pointee != 0 else {
                return "Image encoding failed."
            }

            return String(cString: baseAddress)
        }
    }

    private func withLock<Result>(_ operation: () throws -> Result) rethrows -> Result {
        self.lock.lock()
        defer { self.lock.unlock() }
        return try operation()
    }
}
