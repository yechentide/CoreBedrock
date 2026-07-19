//
// Created by yechentide on 2026/07/19
//

@testable import CoreBedrock
import CoreGraphics
import Foundation
import Testing

struct CBImageScanlineWriterTests {
    @Test
    func writesPNGInMultipleBatches() throws {
        let outputURL = Self.temporaryURL(fileExtension: "png")
        defer { try? FileManager.default.removeItem(at: outputURL) }

        let writer = try CBImageScanlineWriter(
            outputURL: outputURL,
            width: 2,
            height: 2,
            format: .png
        )
        try writer.write(
            rows: Data([255, 0, 0, 255, 0, 255, 0, 255]),
            bytesPerRow: 8,
            rowCount: 1
        )
        try writer.write(
            rows: Data([0, 0, 255, 255, 255, 255, 255, 0]),
            bytesPerRow: 8,
            rowCount: 1
        )
        try writer.finish()

        #expect(writer.isFinished)
        #expect(writer.bytesWritten > 0)
        let image = CGImage.loadPNG(url: outputURL)
        #expect(image?.width == 2)
        #expect(image?.height == 2)
    }

    @Test
    func writesJPEGWithAlphaBackground() throws {
        let outputURL = Self.temporaryURL(fileExtension: "jpg")
        defer { try? FileManager.default.removeItem(at: outputURL) }

        let writer = try CBImageScanlineWriter(
            outputURL: outputURL,
            width: 2,
            height: 1,
            format: .jpeg(
                quality: 90,
                background: .init(red: 255, green: 255, blue: 255)
            )
        )
        try writer.write(
            rows: Data([255, 0, 0, 255, 0, 0, 0, 0]),
            bytesPerRow: 8,
            rowCount: 1
        )
        try writer.finish()

        #expect(writer.bytesWritten > 0)
        let image = CGImage.loadJPG(url: outputURL)
        #expect(image?.width == 2)
        #expect(image?.height == 1)
    }

    @Test
    func rejectsIncompleteAndUndersizedRows() throws {
        let outputURL = Self.temporaryURL(fileExtension: "png")
        let writer = try CBImageScanlineWriter(
            outputURL: outputURL,
            width: 2,
            height: 1,
            format: .png
        )

        #expect(throws: CBImageScanlineWriterError.invalidRowData) {
            try writer.write(rows: Data(count: 4), bytesPerRow: 8, rowCount: 1)
        }
        #expect(throws: CBImageScanlineWriterError.encoderFailure("The image has incomplete rows.")) {
            try writer.finish()
        }

        writer.cancel()
        #expect(!FileManager.default.fileExists(atPath: outputURL.path))
    }

    private static func temporaryURL(fileExtension: String) -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(fileExtension)
    }
}
