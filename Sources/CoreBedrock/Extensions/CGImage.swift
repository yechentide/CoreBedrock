//
// Created by yechentide on 2025/04/12
//

import CoreGraphics
import ImageIO
import OSLog
import UniformTypeIdentifiers

public struct RGBA: Sendable {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    let alpha: UInt8
}

public extension CGImage {
    static func from(
        colors: [RGBA],
        width: Int,
        height: Int,
        flipVertically: Bool = false,
        flipHorizontally: Bool = false
    ) -> CGImage? {
        guard colors.count == width * height else {
            return nil
        }

        var pixelData = [UInt8](repeating: 0, count: colors.count * 4)

        for y in 0..<height {
            for x in 0..<width {
                var srcX = x
                var srcY = y
                if flipHorizontally {
                    srcX = width - 1 - x
                }
                if flipVertically {
                    srcY = height - 1 - y
                }

                let srcIndex = srcY * width + srcX
                let destIndex = (y * width + x) * 4
                let color = colors[srcIndex]
                pixelData[destIndex + 0] = color.red
                pixelData[destIndex + 1] = color.green
                pixelData[destIndex + 2] = color.blue
                pixelData[destIndex + 3] = color.alpha
            }
        }

        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let providerRef = CGDataProvider(data: NSData(bytes: pixelData, length: pixelData.count)) else {
            return nil
        }

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        return CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerComponent * bytesPerPixel,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )
    }

    func encode(as type: UTType = .png) -> Data? {
        let data = NSMutableData()
        let uti = type.identifier as CFString
        guard let destination = CGImageDestinationCreateWithData(data as CFMutableData, uti, 1, nil) else {
            CBLogger.error("Failed to create CGImageDestination for UTI: \(uti)")
            return nil
        }

        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else {
            CBLogger.error("Failed to finalize image encoding for UTI: \(uti)")
            return nil
        }

        return data as Data
    }

    static func decode(from data: Data, as type: UTType? = nil) -> CGImage? {
        var options: [CFString: Any] = [:]
        if let type {
            options[kCGImageSourceTypeIdentifierHint] = type.identifier as CFString
        }
        guard let source = CGImageSourceCreateWithData(data as CFData, options as CFDictionary),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else {
            CBLogger.error("Failed to decode CGImage from data. Type hint: \(type?.identifier ?? "none")")
            return nil
        }

        return cgImage
    }

    func save(to url: URL, as type: UTType = .png, properties: [CFString: Any]? = nil) throws {
        let uti = type.identifier as CFString

        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, uti, 1, nil) else {
            CBLogger.error("Failed to create CGImageDestination for \(uti)")
            throw CBError.failedSaveImage(url)
        }

        CGImageDestinationAddImage(destination, self, properties as CFDictionary?)

        guard CGImageDestinationFinalize(destination) else {
            CBLogger.error("Failed to finalize image write to \(url.absoluteString)")
            throw CBError.failedSaveImage(url)
        }
    }
}

public extension CGImage {
    // swiftlint:disable line_length

    /// Load image from a png file
    ///
    /// [ref](https://stackoverflow.com/questions/71160917/swift-the-simpliest-way-to-load-a-local-png-jpg-image-file-to-a-uint8-uint16-ar)
    /// - Parameter url: the url of a png file
    /// - Returns: CGImage
    static func loadPNG(url: URL) -> CGImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let cgProvider = CGDataProvider(data: data as CFData) else { return nil }

        return CGImage(
            pngDataProviderSource: cgProvider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )
    }

    // swiftlint:enable line_length

    static func loadJPG(url: URL) -> CGImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let cgProvider = CGDataProvider(data: data as CFData) else { return nil }

        return CGImage(
            jpegDataProviderSource: cgProvider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )
    }
}
