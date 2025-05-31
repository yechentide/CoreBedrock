//
// Created by yechentide on 2025/05/25
//

import Testing
import Foundation
import CoreGraphics
@testable import CoreBedrock

struct CGImageTests {
    static let testDataURL = Bundle.module.url(forResource: "TestData", withExtension: nil)!

    @Test
    func testLoadPNG() throws {
        let pngURL = Self.testDataURL.appendingPathComponent("grass.png")
        let image = CGImage.loadPNG(url: pngURL)
        guard let image else {
            Issue.record("Failed to load PNG image")
            return
        }
        #expect(image.width == 16)
        #expect(image.height == 16)
    }

    @Test
    func testLoadJPG() throws {
        let jpgURL = Self.testDataURL.appendingPathComponent("grass.jpg")
        let image = CGImage.loadJPG(url: jpgURL)
        guard let image else {
            Issue.record("Failed to load JPG image")
            return
        }
        #expect(image.width == 16)
        #expect(image.height == 16)
    }

    @Test
    func testLoadInvalidFile() throws {
        let invalidURL = Self.testDataURL.appendingPathComponent("nonexistent.png")
        let pngImage = CGImage.loadPNG(url: invalidURL)
        guard pngImage == nil else {
            Issue.record("PNG image should be nil for invalid file")
            return
        }
        
        let jpgImage = CGImage.loadJPG(url: invalidURL)
        guard jpgImage == nil else {
            Issue.record("JPG image should be nil for invalid file")
            return
        }
    }
}
