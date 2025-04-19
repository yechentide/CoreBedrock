//
// Created by yechentide on 2025/04/09
//

import CoreGraphics

extension CGColor {
    public static func from(red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat) -> CGColor {
        return CGColor(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: alpha
        )
    }

    public static func from(red: UInt8, green: UInt8, blue: UInt8) -> CGColor {
        return Self.from(red: red, green: green, blue: blue, alpha: 1.0)
    }

    fileprivate var rgbaComponents: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
        guard let components = self.components,
              let colorSpace = self.colorSpace?.model
        else {
            return nil
        }

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1
        switch colorSpace {
            case .monochrome:
                // グレースケール + alpha
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

    public var argbColor: UInt32? {
        guard let (r, g, b, a) = self.rgbaComponents else {
            return nil
        }
        let A = UInt32(a * 255) << 24
        let R = UInt32(r * 255) << 16
        let G = UInt32(g * 255) << 8
        let B = UInt32(b * 255)
        return A | R | G | B
    }

    public var argbHexString: String? {
        guard let argb = self.argbColor else { return nil }
        return String(format: "#%08X", argb)
    }

    public var rgbaColor: UInt32? {
        guard let (r, g, b, a) = self.rgbaComponents else {
            return nil
        }
        let R = UInt32(r * 255) << 24
        let G = UInt32(g * 255) << 16
        let B = UInt32(b * 255) << 8
        let A = UInt32(a * 255)
        return R | G | B | A
    }

    public var rgbaHexString: String? {
        guard let rgba = self.rgbaColor else { return nil }
        return String(format: "#%08X", rgba)
    }
}
