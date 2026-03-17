//
// Created by yechentide on 2025/04/12
//

import CoreGraphics
import Foundation

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
