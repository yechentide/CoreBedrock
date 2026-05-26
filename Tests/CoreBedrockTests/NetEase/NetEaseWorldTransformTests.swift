@testable import CoreBedrock
import Foundation
import Testing

struct NetEaseWorldTransformTests {
    @Test(.withTemporaryNetEaseWorld)
    func decryptWorldSavesDerivedKeyFile() throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"
        let currentFilePath = "\(dbDirPath)/CURRENT"
        let currentFileData = try Data(contentsOf: URL(fileURLWithPath: currentFilePath))
        let expectedKey = try NetEaseKeyDerivation.deriveKey(
            dbDirPath: dbDirPath,
            currentFileData: currentFileData
        )

        try NetEaseWorldTransform.decryptWorld(at: worldDirPath)

        let keyFilePath = "\(worldDirPath)/\(NetEaseConstants.keyFileName)"
        let savedKeyHex = try String(contentsOfFile: keyFilePath, encoding: .utf8)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let expectedKeyHex = expectedKey.map { String(format: "%02x", $0) }.joined()

        #expect(savedKeyHex == expectedKeyHex)
    }

    @Test(.withTemporaryNetEaseWorld)
    func encryptWorldWithoutExplicitKeyUsesSavedKeyFile() throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath

        try NetEaseWorldTransform.decryptWorld(at: worldDirPath)
        try NetEaseWorldTransform.encryptWorld(at: worldDirPath)

        let currentFilePath = "\(worldDirPath)/db/CURRENT"
        let currentFileData = try Data(contentsOf: URL(fileURLWithPath: currentFilePath))
        let currentFileHeader = NetEaseHeader.identifyHeader(in: currentFileData, isCurrentFile: true)

        #expect(currentFileHeader == .neteaseEncrypted)
    }

    @Test
    func defaultKeyUsesGoCompatibleValue() {
        #expect(NetEaseConstants.defaultKey == Data("88329851".utf8))
    }
}
