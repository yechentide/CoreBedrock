//
// Created by yechentide on 2025/04/12
//

import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
import OSLog

extension CGImage {
    public static func from(
        colors: [CGColor],
        width: Int,
        height: Int,
        flipVertically: Bool = false,
        flipHorizontally: Bool = false
    ) -> CGImage? {
        guard colors.count == width * height else {
            CBLogger.warning("The number of colors does not match the image dimensions.")
            return nil
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let alphaInfo = CGImageAlphaInfo.premultipliedLast
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: alphaInfo.rawValue))
        let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )

        guard let context else {
            CBLogger.warning("Failed to create CGContext.")
            return nil
        }

        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                let color = colors[index]
                let drawX = flipHorizontally ? (width - 1 - x) : x
                let drawY = flipVertically ? (height - 1 - y) : y
                context.setFillColor(color)
                context.fill(CGRect(x: drawX, y: drawY, width: 1, height: 1))
            }
        }
        return context.makeImage()
    }

    public func encode(as type: UTType = .png) -> Data? {
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

    public static func decode(from data: Data, as type: UTType? = nil) -> CGImage? {
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

    public func save(to url: URL, as type: UTType = .png, properties: [CFString: Any]? = nil) throws {
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
