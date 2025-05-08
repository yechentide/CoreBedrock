//
// Created by yechentide on 2025/05/04
//

import Testing
import Foundation
import CoreGraphics
import LvDBWrapper
@testable import CoreBedrock

struct MyTest {
    @Test
    func loadRegion() async throws {
        try measureExecutionTime(for: "load region 0, 0") {
            let dirURL = URL(filePath: "/private/tmp/test/test-world")
            let world = try MCWorld(from: dirURL)
            guard let _ = try RegionTextureLoader.load(
                db: world.db, worldDirURL: dirURL, dimension: .overworld,
                region: .init(x: 0, z: 0), lastPlayed: nil, useCache: false
            ) else {
                print("cgImage is nil")
                return
            }
//            try cgImage.save(to: URL(filePath: "/private/tmp/test/r.0.0.png"), as: .png)
        }
    }
}
