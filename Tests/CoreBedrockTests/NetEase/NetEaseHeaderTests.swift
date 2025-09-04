import Testing
import Foundation
@testable import CoreBedrock

struct NetEaseHeaderTests {
    @Test
    func testNetEaseEncryptedData() async {
        let header = NetEaseHeader.neteaseEncrypted
        let expectedData = Data([0x80, 0x1D, 0x30, 0x01])

        #expect(header.data == expectedData)
        #expect(header.data.count == 4)
    }

    @Test
    func testBedrockCurrentFileData() async {
        let header = NetEaseHeader.bedrockCurrentFile
        let expectedData = Data([0x4D, 0x41, 0x4E, 0x49]) // "MANI"

        #expect(header.data == expectedData)
        #expect(header.data.count == 4)

        let stringRepresentation = String(data: header.data, encoding: .ascii)
        #expect(stringRepresentation == "MANI")
    }

    @Test
    func testUnknownData() async {
        let header = NetEaseHeader.unknown
        let expectedData = Data()

        #expect(header.data == expectedData)
        #expect(header.data.isEmpty)
    }

    @Test
    func testIdentifyNetEaseEncryptedHeader() async {
        let data = Data([0x80, 0x1D, 0x30, 0x01, 0x12, 0x34])

        let resultAsCurrentFile = NetEaseHeader.identifyHeader(in: data, isCurrentFile: true)
        let resultAsRegularFile = NetEaseHeader.identifyHeader(in: data, isCurrentFile: false)

        #expect(resultAsCurrentFile == .neteaseEncrypted)
        #expect(resultAsRegularFile == .neteaseEncrypted)
    }

    @Test
    func testIdentifyBedrockCurrentFileHeader() async {
        let data = Data([0x4D, 0x41, 0x4E, 0x49, 0x56, 0x78])

        let resultAsCurrentFile = NetEaseHeader.identifyHeader(in: data, isCurrentFile: true)
        let resultAsRegularFile = NetEaseHeader.identifyHeader(in: data, isCurrentFile: false)

        #expect(resultAsCurrentFile == .bedrockCurrentFile)
        #expect(resultAsRegularFile == .unknown)
    }

    @Test
    func testIdentifyHeaderWithShortData() async {
        let shortData = Data([0x80, 0x1D])

        let result = NetEaseHeader.identifyHeader(in: shortData, isCurrentFile: false)

        #expect(result == .unknown)
    }

    @Test
    func testIdentifyHeaderWithEmptyData() async {
        let emptyData = Data()

        let result = NetEaseHeader.identifyHeader(in: emptyData, isCurrentFile: true)

        #expect(result == .unknown)
    }

    @Test
    func testIdentifyHeaderWithUnknownPattern() async {
        let unknownData = Data([0x12, 0x34, 0x56, 0x78, 0x9A])

        let resultAsCurrentFile = NetEaseHeader.identifyHeader(in: unknownData, isCurrentFile: true)
        let resultAsRegularFile = NetEaseHeader.identifyHeader(in: unknownData, isCurrentFile: false)

        #expect(resultAsCurrentFile == .unknown)
        #expect(resultAsRegularFile == .unknown)
    }

    @Test
    func testValidateWithUnknownExpectedHeader() async throws {
        let anyData = Data([0x12, 0x34, 0x56, 0x78])

        try NetEaseHeader.validate(currentFileData: anyData, shouldHasHeader: .unknown)
    }

    @Test
    func testValidateExpectingBedrockCurrentFileSuccess() async throws {
        let bedrockData = Data([0x4D, 0x41, 0x4E, 0x49, 0x56, 0x78])

        try NetEaseHeader.validate(currentFileData: bedrockData, shouldHasHeader: .bedrockCurrentFile)
    }

    @Test
    func testValidateExpectingBedrockCurrentFileButAlreadyEncrypted() async throws {
        let encryptedData = Data([0x80, 0x1D, 0x30, 0x01, 0x12, 0x34])

        #expect(throws: NetEaseError.alreadyEncrypted) {
            try NetEaseHeader.validate(currentFileData: encryptedData, shouldHasHeader: .bedrockCurrentFile)
        }
    }

    @Test
    func testValidateExpectingNetEaseEncryptedSuccess() async throws {
        let encryptedData = Data([0x80, 0x1D, 0x30, 0x01, 0x12, 0x34])

        try NetEaseHeader.validate(currentFileData: encryptedData, shouldHasHeader: .neteaseEncrypted)
    }

    @Test
    func testValidateExpectingNetEaseEncryptedButAlreadyDecrypted() async throws {
        let bedrockData = Data([0x4D, 0x41, 0x4E, 0x49, 0x56, 0x78])

        #expect(throws: NetEaseError.alreadyDecrypted) {
            try NetEaseHeader.validate(currentFileData: bedrockData, shouldHasHeader: .neteaseEncrypted)
        }
    }

    @Test
    func testValidateWithInvalidHeader() async throws {
        let invalidData = Data([0x12, 0x34, 0x56, 0x78])

        #expect(throws: NetEaseError.invalidHeader) {
            try NetEaseHeader.validate(currentFileData: invalidData, shouldHasHeader: .bedrockCurrentFile)
        }

        #expect(throws: NetEaseError.invalidHeader) {
            try NetEaseHeader.validate(currentFileData: invalidData, shouldHasHeader: .neteaseEncrypted)
        }
    }

    @Test
    func testValidateWithShortData() async throws {
        let shortData = Data([0x12, 0x34])

        #expect(throws: NetEaseError.invalidHeader) {
            try NetEaseHeader.validate(currentFileData: shortData, shouldHasHeader: .bedrockCurrentFile)
        }
    }

    @Test
    func testAllHeaderTypesHaveConsistentDataProperty() async {
        let neteaseData = NetEaseHeader.neteaseEncrypted.data
        let bedrockData = NetEaseHeader.bedrockCurrentFile.data
        let unknownData = NetEaseHeader.unknown.data

        #expect(neteaseData.count == 4)
        #expect(bedrockData.count == 4)
        #expect(unknownData.count == 0)

        #expect(neteaseData != bedrockData)
        #expect(neteaseData != unknownData)
        #expect(bedrockData != unknownData)
    }

    @Test
    func testIdentifyHeaderConsistencyWithDataProperty() async {
        let neteaseData = NetEaseHeader.neteaseEncrypted.data + Data([0x00, 0x00])
        let bedrockData = NetEaseHeader.bedrockCurrentFile.data + Data([0x00, 0x00])

        let identifiedNetease = NetEaseHeader.identifyHeader(in: neteaseData, isCurrentFile: false)
        let identifiedBedrock = NetEaseHeader.identifyHeader(in: bedrockData, isCurrentFile: true)

        #expect(identifiedNetease == .neteaseEncrypted)
        #expect(identifiedBedrock == .bedrockCurrentFile)

        #expect(identifiedNetease.data == NetEaseHeader.neteaseEncrypted.data)
        #expect(identifiedBedrock.data == NetEaseHeader.bedrockCurrentFile.data)
    }

    @Test
    func testValidateWithComplexScenarios() async throws {
        let bedrockData = NetEaseHeader.bedrockCurrentFile.data + Data([0x01, 0x02, 0x03])
        let encryptedData = NetEaseHeader.neteaseEncrypted.data + Data([0x04, 0x05, 0x06])

        try NetEaseHeader.validate(currentFileData: bedrockData, shouldHasHeader: .bedrockCurrentFile)
        try NetEaseHeader.validate(currentFileData: encryptedData, shouldHasHeader: .neteaseEncrypted)

        #expect(throws: NetEaseError.alreadyEncrypted) {
            try NetEaseHeader.validate(currentFileData: encryptedData, shouldHasHeader: .bedrockCurrentFile)
        }

        #expect(throws: NetEaseError.alreadyDecrypted) {
            try NetEaseHeader.validate(currentFileData: bedrockData, shouldHasHeader: .neteaseEncrypted)
        }
    }
}
