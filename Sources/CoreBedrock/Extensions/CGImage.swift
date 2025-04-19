//
// Created by yechentide on 2025/04/12
//

import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
import OSLog

extension CGImage {
    public static func from(colors: [CGColor], width: Int, height: Int) -> CGImage? {
        guard colors.count == width * height else {
            OSLog.cbLogger.warning("The number of colors does not match the image dimensions.")
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
            OSLog.cbLogger.warning("Failed to create CGContext.")
            return nil
        }

        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                context.setFillColor(colors[index])
                context.fill(CGRect(x: x, y: height - 1 - y, width: 1, height: 1))
            }
        }
        return context.makeImage()
    }

    public func saveAsPNG(to url: URL) throws {
        let pngUTType = UTType.png.identifier as CFString
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, pngUTType, 1, nil) else {
            throw CBError.failedSaveImage(url)
        }
        CGImageDestinationAddImage(destination, self, nil)
        if !CGImageDestinationFinalize(destination) {
            throw CBError.failedSaveImage(url)
        }
    }
}
