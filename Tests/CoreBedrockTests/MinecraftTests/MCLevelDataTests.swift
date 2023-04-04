import XCTest
@testable import CoreBedrock

final class MCLevelDataTests: XCTestCase {
    var fileURL: URL!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let path = try XCTUnwrap( Bundle.module.path(forResource: "world/level", ofType: "dat") )
        fileURL = URL(fileURLWithPath: path)
    }
    
    func testInit() throws {
        let _ = try XCTUnwrap( MCLevelData(srcURL: fileURL) )
    }
    
    func testComputedProperty() throws {
        var levelData = try XCTUnwrap( MCLevelData(srcURL: fileURL) )
        XCTAssertEqual("ParseIt", levelData.worldName)
        
        let newName = "abcdefg"
        levelData.worldName = newName
        XCTAssertEqual(newName, levelData.worldName)
    }
}
