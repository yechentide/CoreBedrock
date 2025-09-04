import Testing
import Foundation
@testable import CoreBedrock

struct NetEaseKeyDerivationTests {
    @Test(.withTemporaryNetEaseWorld)
    func testDeriveKeySuccess() async throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        // Create a valid CURRENT file with proper format
        let header = NetEaseHeader.bedrockCurrentFile.data

        // Create key material that will result in matching first8 and last8
        // The manifest is "MANIFEST-000048\n" (16 bytes)
        let manifestBytes = Data("MANIFEST-000048\n".utf8)
        #expect(manifestBytes.count == NetEaseConstants.expectedManifestLength)

        // Create current body that when XORed with manifest gives us matching 8+8 pattern
        let desiredKey = Data([0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0])
        let keyPattern = desiredKey + desiredKey // 16 bytes: first 8 == last 8

        var currentBody = Data(count: NetEaseConstants.expectedKeyLength)
        for index in 0..<NetEaseConstants.expectedKeyLength {
            currentBody[index] = keyPattern[index] ^ manifestBytes[index]
        }

        let currentFileData = header + currentBody

        let derivedKey = try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)

        #expect(derivedKey == desiredKey)
        #expect(derivedKey.count == 8)
    }

    @Test(.withTemporaryNetEaseWorld)
    func testDeriveKeyWithInvalidCurrentFileData() async throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        let header = NetEaseHeader.bedrockCurrentFile.data
        let shortBody = Data([0x01, 0x02, 0x03]) // Too short (< 16 bytes)
        let currentFileData = header + shortBody

        #expect(throws: NetEaseError.invalidCurrentFileData) {
            try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)
        }
    }

    @Test(.withTemporaryNetEaseWorld)
    func testDeriveKeyWithKeyVerificationFailure() async throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        let header = NetEaseHeader.bedrockCurrentFile.data

        // Create current body that results in first8 != last8
        let manifestBytes = Data("MANIFEST-000048\n".utf8)
        let mismatchedKeyPattern = Data([0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88,
                                       0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF, 0x00])

        var currentBody = Data(count: NetEaseConstants.expectedKeyLength)
        for index in 0..<NetEaseConstants.expectedKeyLength {
            currentBody[index] = mismatchedKeyPattern[index] ^ manifestBytes[index]
        }

        let currentFileData = header + currentBody

        #expect(throws: NetEaseError.keyVerificationFailed) {
            try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)
        }
    }

    @Test(.withEmptyDirectory)
    func testDeriveKeyWithNonexistentDbDir() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let nonExistentPath = "\(directoryPath)/does-not-exist"
        let header = NetEaseHeader.bedrockCurrentFile.data
        let validBody = Data(count: NetEaseConstants.expectedKeyLength)
        let currentFileData = header + validBody

        #expect(throws: NetEaseError.dbNotFound(nonExistentPath)) {
            try NetEaseKeyDerivation.deriveKey(dbDirPath: nonExistentPath, currentFileData: currentFileData)
        }
    }

    @Test(.withEmptyDirectory)
    func testDeriveKeyWithEmptyDbDir() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath

        let header = NetEaseHeader.bedrockCurrentFile.data
        let validBody = Data(count: NetEaseConstants.expectedKeyLength)
        let currentFileData = header + validBody

        #expect(throws: NetEaseError.manifestFileNotFound) {
            try NetEaseKeyDerivation.deriveKey(dbDirPath: directoryPath, currentFileData: currentFileData)
        }
    }

    @Test(.withTemporaryNetEaseWorld)
    func testDeriveKeyWithMinimalValidCurrentFile() async throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        let header = NetEaseHeader.bedrockCurrentFile.data

        // Create the minimum valid current file (exactly 16 bytes of body)
        let manifestBytes = Data("MANIFEST-000048\n".utf8)
        let symmetricKey = Data([0xAB, 0xCD, 0xEF, 0x01, 0x23, 0x45, 0x67, 0x89])
        let keyPattern = symmetricKey + symmetricKey

        var currentBody = Data(count: NetEaseConstants.expectedKeyLength)
        for index in 0..<NetEaseConstants.expectedKeyLength {
            currentBody[index] = keyPattern[index] ^ manifestBytes[index]
        }

        let currentFileData = header + currentBody

        let derivedKey = try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)

        #expect(derivedKey == symmetricKey)
        #expect(derivedKey.count == 8)
    }

    @Test(.withTemporaryNetEaseWorld)
    func testDeriveKeyWithExtraDataInCurrentFile() async throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        let header = NetEaseHeader.bedrockCurrentFile.data

        // Create current file with more than 16 bytes of body (should still work)
        let manifestBytes = Data("MANIFEST-000048\n".utf8)
        let symmetricKey = Data([0xDE, 0xAD, 0xBE, 0xEF, 0xCA, 0xFE, 0xBA, 0xBE])
        let keyPattern = symmetricKey + symmetricKey

        var currentBody = Data(count: NetEaseConstants.expectedKeyLength + 10) // Extra 10 bytes
        for index in 0..<NetEaseConstants.expectedKeyLength {
            currentBody[index] = keyPattern[index] ^ manifestBytes[index]
        }
        // Fill extra bytes with random data
        for index in NetEaseConstants.expectedKeyLength..<currentBody.count {
            currentBody[index] = UInt8.random(in: 0...255)
        }

        let currentFileData = header + currentBody

        let derivedKey = try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)

        #expect(derivedKey == symmetricKey)
        #expect(derivedKey.count == 8)
    }

    @Test(.withTemporaryNetEaseWorld)
    func testDeriveKeyXOROperation() async throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        let header = NetEaseHeader.bedrockCurrentFile.data

        // Test specific XOR operation with known values
        let manifestBytes = Data("MANIFEST-000048\n".utf8)
        #expect(manifestBytes.count == 16)

        // Create a known key pattern
        let knownKey = Data([0xFF, 0x00, 0xAA, 0x55, 0x33, 0xCC, 0x0F, 0xF0])
        let keyPattern = knownKey + knownKey

        // Calculate what current body should be
        var expectedCurrentBody = Data(count: NetEaseConstants.expectedKeyLength)
        for index in 0..<NetEaseConstants.expectedKeyLength {
            expectedCurrentBody[index] = keyPattern[index] ^ manifestBytes[index]
        }

        let currentFileData = header + expectedCurrentBody

        let derivedKey = try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)

        #expect(derivedKey == knownKey)

        // Verify the XOR operation worked correctly
        for index in 0..<8 {
            let currentByte = expectedCurrentBody[index]
            let manifestByte = manifestBytes[index]
            let derivedByte = derivedKey[index]
            #expect(currentByte ^ manifestByte == derivedByte,
                   "XOR operation failed at index \(index): \(currentByte) ^ \(manifestByte) != \(derivedByte)")
        }
    }

    @Test(.withTemporaryNetEaseWorld)
    func testDeriveKeyConsistency() async throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        let header = NetEaseHeader.bedrockCurrentFile.data
        let manifestBytes = Data("MANIFEST-000048\n".utf8)
        let testKey = Data([0x42, 0x24, 0x84, 0x48, 0x36, 0x63, 0x72, 0x27])
        let keyPattern = testKey + testKey

        var currentBody = Data(count: NetEaseConstants.expectedKeyLength)
        for index in 0..<NetEaseConstants.expectedKeyLength {
            currentBody[index] = keyPattern[index] ^ manifestBytes[index]
        }

        let currentFileData = header + currentBody

        // Run derivation multiple times to ensure consistency
        let derivedKey1 = try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)
        let derivedKey2 = try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)
        let derivedKey3 = try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)

        #expect(derivedKey1 == derivedKey2)
        #expect(derivedKey2 == derivedKey3)
        #expect(derivedKey1 == testKey)
    }

    @Test(.withTemporaryNetEaseWorld)
    func testDeriveKeyEdgeCaseAllZeros() async throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        let header = NetEaseHeader.bedrockCurrentFile.data
        let manifestBytes = Data("MANIFEST-000048\n".utf8)
        let zeroKey = Data(count: 8) // All zeros
        let keyPattern = zeroKey + zeroKey

        var currentBody = Data(count: NetEaseConstants.expectedKeyLength)
        for index in 0..<NetEaseConstants.expectedKeyLength {
            currentBody[index] = keyPattern[index] ^ manifestBytes[index]
        }

        let currentFileData = header + currentBody

        let derivedKey = try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)

        #expect(derivedKey == zeroKey)
        #expect(derivedKey.allSatisfy { $0 == 0 })
    }

    @Test(.withTemporaryNetEaseWorld)
    func testDeriveKeyEdgeCaseAllOnes() async throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        let header = NetEaseHeader.bedrockCurrentFile.data
        let manifestBytes = Data("MANIFEST-000048\n".utf8)
        let onesKey = Data(repeating: 0xFF, count: 8) // All 0xFF
        let keyPattern = onesKey + onesKey

        var currentBody = Data(count: NetEaseConstants.expectedKeyLength)
        for index in 0..<NetEaseConstants.expectedKeyLength {
            currentBody[index] = keyPattern[index] ^ manifestBytes[index]
        }

        let currentFileData = header + currentBody

        let derivedKey = try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)

        #expect(derivedKey == onesKey)
        #expect(derivedKey.allSatisfy { $0 == 0xFF })
    }
}
