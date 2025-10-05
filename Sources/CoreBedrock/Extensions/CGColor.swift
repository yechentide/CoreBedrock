//
// Created by yechentide on 2025/04/09
//

import CoreGraphics

public extension CGColor {
    static func from(red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat) -> CGColor {
        CGColor(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: alpha
        )
    }

    static func from(red: UInt8, green: UInt8, blue: UInt8) -> CGColor {
        Self.from(red: red, green: green, blue: blue, alpha: 1.0)
    }

    static func parseAsARGB(_ argb: UInt32) -> CGColor {
        let a = CGFloat((argb >> 24) & 0xFF) / 255.0
        let r = CGFloat((argb >> 16) & 0xFF) / 255.0
        let g = CGFloat((argb >> 8) & 0xFF) / 255.0
        let b = CGFloat(argb & 0xFF) / 255.0
        return CGColor(red: r, green: g, blue: b, alpha: a)
    }

    static func parseAsRGBA(_ rgba: UInt32) -> CGColor {
        let r = CGFloat((rgba >> 24) & 0xFF) / 255.0
        let g = CGFloat((rgba >> 16) & 0xFF) / 255.0
        let b = CGFloat((rgba >> 8) & 0xFF) / 255.0
        let a = CGFloat(rgba & 0xFF) / 255.0
        return CGColor(red: r, green: g, blue: b, alpha: a)
    }

    // swiftlint:disable:next large_tuple
    private var rgbaComponents: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
        guard let components = self.components,
              let colorSpace = self.colorSpace?.model
        else {
            return nil
        }

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        switch colorSpace {
        case .monochrome:
            // Grayscale + alpha
            r = components[0]
            g = components[0]
            b = components[0]
            a = components.count >= 2 ? components[1] : 1
        case .rgb:
            // RGB + alpha
            r = components[0]
            g = components[1]
            b = components[2]
            a = components.count >= 4 ? components[3] : 1
        default:
            return nil
        }
        return (r, g, b, a)
    }

    var argbColor: UInt32? {
        guard let (r, g, b, a) = self.rgbaComponents else {
            return nil
        }

        let A = UInt32((a * 255).rounded()) << 24
        let R = UInt32((r * 255).rounded()) << 16
        let G = UInt32((g * 255).rounded()) << 8
        let B = UInt32((b * 255).rounded())
        return A | R | G | B
    }

    var argbHexString: String? {
        guard let argb = self.argbColor else { return nil }

        return String(format: "#%08X", argb)
    }

    var rgbaColor: UInt32? {
        guard let (r, g, b, a) = self.rgbaComponents else {
            return nil
        }

        let R = UInt32((r * 255).rounded()) << 24
        let G = UInt32((g * 255).rounded()) << 16
        let B = UInt32((b * 255).rounded()) << 8
        let A = UInt32((a * 255).rounded())
        return R | G | B | A
    }

    var rgbaHexString: String? {
        guard let rgba = self.rgbaColor else { return nil }

        return String(format: "#%08X", rgba)
    }
}
