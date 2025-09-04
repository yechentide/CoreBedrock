import Testing
import Foundation
@testable import CoreBedrock

struct NetEaseCryptoTests {
    @Test
    func testApplyXORWithEmptyKey() async {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        let key = Data()

        let result = NetEaseCrypto.applyXOR(to: data, with: key)

        #expect(result == data)
    }

    @Test
    func testApplyXORWithSingleByteKey() async {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        let key = Data([0xFF])

        let result = NetEaseCrypto.applyXOR(to: data, with: key)
        let expected = Data([0xFE, 0xFD, 0xFC, 0xFB])

        #expect(result == expected)
    }

    @Test
    func testApplyXORWithMultiByteKey() async {
        let data = Data([0x01, 0x02, 0x03, 0x04, 0x05, 0x06])
        let key = Data([0xFF, 0x00])

        let result = NetEaseCrypto.applyXOR(to: data, with: key)
        let expected = Data([0xFE, 0x02, 0xFC, 0x04, 0xFA, 0x06])

        #expect(result == expected)
    }

    @Test
    func testApplyXORIsReversible() async {
        let originalData = Data([0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0])
        let key = Data([0xAB, 0xCD, 0xEF])

        let encrypted = NetEaseCrypto.applyXOR(to: originalData, with: key)
        let decrypted = NetEaseCrypto.applyXOR(to: encrypted, with: key)

        #expect(decrypted == originalData)
    }

    @Test
    func testApplyXORWithEmptyData() async {
        let data = Data()
        let key = Data([0xFF, 0x00])

        let result = NetEaseCrypto.applyXOR(to: data, with: key)

        #expect(result == Data())
    }

    @Test
    func testDecryptFileSuccess() async throws {
        let header = NetEaseHeader.neteaseEncrypted.data
        let encryptedBody = Data([0x12, 0x34, 0x56, 0x78])
        let fileData = header + encryptedBody
        let key = Data([0xFF, 0x00])

        let result = try NetEaseCrypto.decryptFile(data: fileData, key: key)
        let expected = Data([0xED, 0x34, 0xA9, 0x78])

        #expect(result == expected)
    }

    @Test
    func testDecryptFileWithMinimalData() async throws {
        let header = NetEaseHeader.neteaseEncrypted.data
        let fileData = header
        let key = Data([0xFF])

        let result = try NetEaseCrypto.decryptFile(data: fileData, key: key)

        #expect(result == Data())
    }

    @Test
    func testDecryptFileWithShortData() async throws {
        let shortData = Data([0x01, 0x02])
        let key = Data([0xFF])

        let result = try NetEaseCrypto.decryptFile(data: shortData, key: key)

        #expect(result == Data())
    }

    @Test
    func testEncryptFileSuccess() async throws {
        let originalData = Data([0x12, 0x34, 0x56, 0x78])
        let key = Data([0xFF, 0x00])

        let result = try NetEaseCrypto.encryptFile(data: originalData, key: key)

        let expectedHeader = NetEaseHeader.neteaseEncrypted.data
        let expectedBody = Data([0xED, 0x34, 0xA9, 0x78])
        let expected = expectedHeader + expectedBody

        #expect(result == expected)
    }

    @Test
    func testEncryptFileWithEmptyData() async throws {
        let originalData = Data()
        let key = Data([0xFF, 0x00])

        let result = try NetEaseCrypto.encryptFile(data: originalData, key: key)
        let expected = NetEaseHeader.neteaseEncrypted.data

        #expect(result == expected)
    }

    @Test
    func testEncryptThenDecryptRoundTrip() async throws {
        let originalData = Data([0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88])
        let key = Data([0xAA, 0xBB, 0xCC])

        let encrypted = try NetEaseCrypto.encryptFile(data: originalData, key: key)
        let decrypted = try NetEaseCrypto.decryptFile(data: encrypted, key: key)

        #expect(decrypted == originalData)
    }

    @Test
    func testEncryptPreservesHeaderFormat() async throws {
        let originalData = Data([0x01, 0x02, 0x03])
        let key = Data([0xFF])

        let result = try NetEaseCrypto.encryptFile(data: originalData, key: key)

        #expect(result.count >= NetEaseConstants.headerSize)

        let headerBytes = result[0..<NetEaseConstants.headerSize]
        #expect(headerBytes == NetEaseHeader.neteaseEncrypted.data)
    }

    @Test
    func testLargeDataEncryptionDecryption() async throws {
        let largeData = Data((0..<1000).map { UInt8($0 % 256) })
        let key = Data([0x12, 0x34, 0x56, 0x78])

        let encrypted = try NetEaseCrypto.encryptFile(data: largeData, key: key)
        let decrypted = try NetEaseCrypto.decryptFile(data: encrypted, key: key)

        #expect(decrypted == largeData)
    }
}
