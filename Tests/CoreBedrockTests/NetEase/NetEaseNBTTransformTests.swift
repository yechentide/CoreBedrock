@testable import CoreBedrock
import Foundation
import Testing

struct NetEaseNBTTransformTests {
    @Test
    func patchDecodedPlayerDataWithValidNBT() throws {
        // Create valid NBT data that can be read by CBTagReader
        let validNBTData = try CompoundTag(name: "test").toData()

        let result = try NetEaseNBTTransform.patchDecodedPlayerData(validNBTData)

        // Should return nil since the NBT is already valid
        #expect(result == nil, "Valid NBT data should return nil")
    }

    @Test
    func patchDecodedPlayerDataWithInvalidNBTNeedsPatching() throws {
        let bedrockData = Data([
            0x0A, 0x00, 0x00,
            0x07,
            0x0A, 0x00, 0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x44, 0x61, 0x74, 0x61,
            0x03, 0x00, 0x00, 0x00,
            0x11, 0x22, 0x33,
            0x00,
        ])

        var neteaseData = Data(bedrockData)
        neteaseData[3] = 0x08

        let result = try NetEaseNBTTransform.patchDecodedPlayerData(neteaseData)

        #expect(result != nil, "Invalid NBT with signature should be patched")
        #expect(result! == bedrockData)
    }

    @Test
    func patchDecodedPlayerDataWithInvalidNBTNoSignature() throws {
        // Create invalid NBT data without the signature
        let invalidNBTData = Data([0xFF, 0xFE, 0xFD])
        #expect {
            try NetEaseNBTTransform.patchDecodedPlayerData(invalidNBTData)
        } throws: { error in
            guard error is CBStreamError else { return false }

            return true
        }
    }

    @Test
    func patchEncodedPlayerDataSuccess() throws {
        let bedrockData = Data([
            0x0A, 0x00, 0x00,
            0x07,
            0x0A, 0x00, 0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x44, 0x61, 0x74, 0x61,
            0x03, 0x00, 0x00, 0x00,
            0x11, 0x22, 0x33,
            0x00,
        ])

        var neteaseData = Data(bedrockData)
        neteaseData[3] = 0x08

        let result = try NetEaseNBTTransform.patchEncodedPlayerData(bedrockData)

        #expect(result != nil, "Data with byteArray signature should be patched")
        #expect(result! == neteaseData)
    }

    @Test
    func patchEncodedPlayerDataNoSignature() throws {
        // Create data without the required signature
        let inputData = Data([0x01, 0x02, 0x03, 0x04])

        let result = try NetEaseNBTTransform.patchEncodedPlayerData(inputData)

        #expect(result == nil, "Data without signature should return nil")
    }

    @Test
    func patchEncodedPlayerDataEmptyData() throws {
        let inputData = Data()

        let result = try NetEaseNBTTransform.patchEncodedPlayerData(inputData)

        #expect(result == nil, "Empty data should return nil")
    }

    @Test
    func scriptDataSignatureConstants() {
        let signature = NetEaseConstants.scriptDataSignature
        let expectedSignature = Data([
            0x0A, 0x00,
            0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x44, 0x61, 0x74, 0x61,
        ])

        #expect(signature == expectedSignature, "ScriptData signature should match expected bytes")
        #expect(signature.count == 12, "ScriptData signature should be 12 bytes")

        // Verify it represents the NBT structure for "scriptData"
        let stringPart = signature[2...]
        let scriptDataString = String(data: Data(stringPart), encoding: .utf8)
        #expect(scriptDataString == "scriptData", "Should represent 'scriptData' string")
    }

    @Test
    func tagByteConstants() {
        #expect(NetEaseConstants.stringTagByte == 0x08, "String tag byte should be 0x08")
        #expect(NetEaseConstants.byteArrayTagByte == 0x07, "Byte array tag byte should be 0x07")
    }

    @Test
    func partialSignatureMatch() throws {
        // Test with data that has partial signature match but not complete
        let partialSignature = Data([NetEaseConstants.stringTagByte, 0x0A, 0x00]) // Missing most of signature
        let testData = Data([0x01, 0x02]) + partialSignature + Data([0x03, 0x04])

        // This should fail to parse as NBT and also fail to find complete signature
        #expect {
            try NetEaseNBTTransform.patchDecodedPlayerData(testData)
        } throws: { _ in
            // Should throw because neither valid NBT nor contains full signature
            true
        }
    }

    @Test
    func signatureAtDataBoundary() throws {
        // Test with signature at the very beginning of data
        let signatureAtStart = Data([NetEaseConstants.stringTagByte]) + NetEaseConstants.scriptDataSignature

        let result = try NetEaseNBTTransform.patchDecodedPlayerData(signatureAtStart)
        #expect(result != nil, "Should patch signature at start")
        #expect(result![0] == NetEaseConstants.byteArrayTagByte, "Should change to byteArray tag")

        // Test with signature at the very end of data
        let prefix = Data([0x10, 0x20, 0x30])
        let signatureAtEnd = prefix + Data([NetEaseConstants.byteArrayTagByte]) + NetEaseConstants.scriptDataSignature

        let encodingResult = try NetEaseNBTTransform.patchEncodedPlayerData(signatureAtEnd)
        #expect(encodingResult != nil, "Should patch signature at end")
        #expect(encodingResult![prefix.count] == NetEaseConstants.stringTagByte, "Should change to string tag")
    }
}
