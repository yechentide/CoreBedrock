//
// Created by yechentide on 2025/05/25
//

@testable import CoreBedrock
import CoreGraphics
import Testing

struct CGColorTests {
    @Test
    func fromRGBA() {
        // Minimum values
        var color = CGColor.from(red: 0, green: 0, blue: 0, alpha: 0.0)
        #expect(color.components?[0] == 0.0)
        #expect(color.components?[1] == 0.0)
        #expect(color.components?[2] == 0.0)
        #expect(color.components?[3] == 0.0)

        // Middle values
        color = CGColor.from(red: 128, green: 64, blue: 192, alpha: 0.5)
        #expect(color.components?[0] == 128.0 / 255.0)
        #expect(color.components?[1] == 64.0 / 255.0)
        #expect(color.components?[2] == 192.0 / 255.0)
        #expect(color.components?[3] == 0.5)

        // Maximum values
        color = CGColor.from(red: 255, green: 255, blue: 255, alpha: 1.0)
        #expect(color.components?[0] == 1.0)
        #expect(color.components?[1] == 1.0)
        #expect(color.components?[2] == 1.0)
        #expect(color.components?[3] == 1.0)
    }

    @Test
    func fromRGB() {
        // Minimum values
        var color = CGColor.from(red: 0, green: 0, blue: 0)
        #expect(color.components?[0] == 0.0)
        #expect(color.components?[1] == 0.0)
        #expect(color.components?[2] == 0.0)
        #expect(color.components?[3] == 1.0)

        // Middle values
        color = CGColor.from(red: 128, green: 64, blue: 192)
        #expect(color.components?[0] == 128.0 / 255.0)
        #expect(color.components?[1] == 64.0 / 255.0)
        #expect(color.components?[2] == 192.0 / 255.0)
        #expect(color.components?[3] == 1.0)

        // Maximum values
        color = CGColor.from(red: 255, green: 255, blue: 255)
        #expect(color.components?[0] == 1.0)
        #expect(color.components?[1] == 1.0)
        #expect(color.components?[2] == 1.0)
        #expect(color.components?[3] == 1.0)
    }

    @Test
    func testParseAsARGB() {
        // Minimum values (00000000)
        var argb: UInt32 = 0x0000_0000
        var color = CGColor.parseAsARGB(argb)
        #expect(color.components?[0] == 0.0)
        #expect(color.components?[1] == 0.0)
        #expect(color.components?[2] == 0.0)
        #expect(color.components?[3] == 0.0)

        // Middle values (8040C080)
        argb = 0x8040_C080
        color = CGColor.parseAsARGB(argb)
        #expect(color.components?[0] == 64.0 / 255.0) // Red (40)
        #expect(color.components?[1] == 192.0 / 255.0) // Green (C0)
        #expect(color.components?[2] == 128.0 / 255.0) // Blue (80)
        #expect(color.components?[3] == 128.0 / 255.0) // Alpha (80)

        // Maximum values (FFFFFFFF)
        argb = 0xFFFF_FFFF
        color = CGColor.parseAsARGB(argb)
        #expect(color.components?[0] == 1.0)
        #expect(color.components?[1] == 1.0)
        #expect(color.components?[2] == 1.0)
        #expect(color.components?[3] == 1.0)
    }

    @Test
    func testParseAsRGBA() {
        // Minimum values (00000000)
        var rgba: UInt32 = 0x0000_0000
        var color = CGColor.parseAsRGBA(rgba)
        #expect(color.components?[0] == 0.0)
        #expect(color.components?[1] == 0.0)
        #expect(color.components?[2] == 0.0)
        #expect(color.components?[3] == 0.0)

        // Middle values (40C08080)
        rgba = 0x40C0_8080
        color = CGColor.parseAsRGBA(rgba)
        #expect(color.components?[0] == 64.0 / 255.0) // Red (40)
        #expect(color.components?[1] == 192.0 / 255.0) // Green (C0)
        #expect(color.components?[2] == 128.0 / 255.0) // Blue (80)
        #expect(color.components?[3] == 128.0 / 255.0) // Alpha (80)

        // Maximum values (FFFFFFFF)
        rgba = 0xFFFF_FFFF
        color = CGColor.parseAsRGBA(rgba)
        #expect(color.components?[0] == 1.0)
        #expect(color.components?[1] == 1.0)
        #expect(color.components?[2] == 1.0)
        #expect(color.components?[3] == 1.0)
    }

    @Test
    func testArgbColor() {
        // Minimum values
        var color = CGColor.from(red: 0, green: 0, blue: 0, alpha: 0.0)
        var expectedARGB: UInt32 = 0x0000_0000
        #expect(color.argbColor == expectedARGB)

        // Middle values
        color = CGColor.from(red: 128, green: 64, blue: 192, alpha: 0.5)
        expectedARGB = 0x8080_40C0
        #expect(color.argbColor == expectedARGB)

        // Maximum values
        color = CGColor.from(red: 255, green: 255, blue: 255, alpha: 1.0)
        expectedARGB = 0xFFFF_FFFF
        #expect(color.argbColor == expectedARGB)

        // Test Monochrome color
        let grayColorSpace = CGColorSpaceCreateDeviceGray()
        let monochromeColor = CGColor(colorSpace: grayColorSpace, components: [0.5, 0.8])!
        let expectedMonochromeARGB: UInt32 = 0xCC80_8080 // Alpha 0.8 (204), Gray 0.5 (128)
        #expect(monochromeColor.argbColor == expectedMonochromeARGB)

        // Test with unsupported color space (should return nil)
        let cmykColorSpace = CGColorSpaceCreateDeviceCMYK()
        let cmykComponents: [CGFloat] = [0.0, 0.0, 0.0, 1.0, 1.0]
        let unsupportedColor = CGColor(colorSpace: cmykColorSpace, components: cmykComponents)!
        #expect(unsupportedColor.argbColor == nil)
    }

    @Test
    func testArgbHexString() {
        // Minimum values
        var color = CGColor.from(red: 0, green: 0, blue: 0, alpha: 0.0)
        var expectedHexString = "#00000000"
        #expect(color.argbHexString == expectedHexString)

        // Middle values
        color = CGColor.from(red: 128, green: 64, blue: 192, alpha: 0.5)
        expectedHexString = "#808040C0"
        #expect(color.argbHexString == expectedHexString)

        // Maximum values
        color = CGColor.from(red: 255, green: 255, blue: 255, alpha: 1.0)
        expectedHexString = "#FFFFFFFF"
        #expect(color.argbHexString == expectedHexString)

        // Test Monochrome color
        let grayColorSpace = CGColorSpaceCreateDeviceGray()
        let monochromeColor = CGColor(colorSpace: grayColorSpace, components: [0.5, 0.8])!
        let expectedMonochromeHexString = "#CC808080"
        #expect(monochromeColor.argbHexString == expectedMonochromeHexString)

        // Test with unsupported color space (should return nil)
        let cmykColorSpace = CGColorSpaceCreateDeviceCMYK()
        let cmykComponents: [CGFloat] = [0.0, 0.0, 0.0, 1.0, 1.0]
        let unsupportedColor = CGColor(colorSpace: cmykColorSpace, components: cmykComponents)!
        #expect(unsupportedColor.argbHexString == nil)
    }

    @Test
    func testRgbaColor() {
        // Minimum values
        var color = CGColor.from(red: 0, green: 0, blue: 0, alpha: 0.0)
        var expectedRGBA: UInt32 = 0x0000_0000
        #expect(color.rgbaColor == expectedRGBA)

        // Middle values
        color = CGColor.from(red: 128, green: 64, blue: 192, alpha: 0.5)
        expectedRGBA = 0x8040_C080
        #expect(color.rgbaColor == expectedRGBA)

        // Maximum values
        color = CGColor.from(red: 255, green: 255, blue: 255, alpha: 1.0)
        expectedRGBA = 0xFFFF_FFFF
        #expect(color.rgbaColor == expectedRGBA)

        // Test Monochrome color
        let grayColorSpace = CGColorSpaceCreateDeviceGray()
        let monochromeColor = CGColor(colorSpace: grayColorSpace, components: [0.5, 0.8])!
        let expectedMonochromeRGBA: UInt32 = 0x8080_80CC // Red 0.5 (128), Green 0.5 (128), Blue 0.5 (128), Alpha 0.8 (204) // swiftlint:disable:this line_length
        #expect(monochromeColor.rgbaColor == expectedMonochromeRGBA)

        // Test with unsupported color space (should return nil)
        let cmykColorSpace = CGColorSpaceCreateDeviceCMYK()
        let cmykComponents: [CGFloat] = [0.0, 0.0, 0.0, 1.0, 1.0]
        let unsupportedColor = CGColor(colorSpace: cmykColorSpace, components: cmykComponents)!
        #expect(unsupportedColor.rgbaColor == nil)
    }

    @Test
    func testRgbaHexString() {
        // Minimum values
        var color = CGColor.from(red: 0, green: 0, blue: 0, alpha: 0.0)
        var expectedHexString = "#00000000"
        #expect(color.rgbaHexString == expectedHexString)

        // Middle values
        color = CGColor.from(red: 128, green: 64, blue: 192, alpha: 0.5)
        expectedHexString = "#8040C080"
        #expect(color.rgbaHexString == expectedHexString)

        // Maximum values
        color = CGColor.from(red: 255, green: 255, blue: 255, alpha: 1.0)
        expectedHexString = "#FFFFFFFF"
        #expect(color.rgbaHexString == expectedHexString)

        // Test Monochrome color
        let grayColorSpace = CGColorSpaceCreateDeviceGray()
        let monochromeColor = CGColor(colorSpace: grayColorSpace, components: [0.5, 0.8])!
        let expectedMonochromeHexString = "#808080CC"
        #expect(monochromeColor.rgbaHexString == expectedMonochromeHexString)

        // Test with unsupported color space (should return nil)
        let cmykColorSpace = CGColorSpaceCreateDeviceCMYK()
        let cmykComponents: [CGFloat] = [0.0, 0.0, 0.0, 1.0, 1.0]
        let unsupportedColor = CGColor(colorSpace: cmykColorSpace, components: cmykComponents)!
        #expect(unsupportedColor.rgbaHexString == nil)
    }
}
