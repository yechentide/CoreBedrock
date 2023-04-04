import Foundation
import CoreGraphics

public struct MCDir: Identifiable {
    public var id = UUID()

    public let dirURL: URL
    private let useSecurityScope: Bool

    public var worldName: String = "Unknown"
    public var worldImage: CGImage? = nil

    public static func isMCWorldDir(dirURL: URL, useSecurityScope: Bool) throws -> Bool {
        guard !useSecurityScope || dirURL.startAccessingSecurityScopedResource() else {
            throw CBLvDBError.invalidSecurityScope(dirURL)
        }
        defer {
            if useSecurityScope { dirURL.stopAccessingSecurityScopedResource() }
        }

        var (hasDB, hasLevelDat, hasLevelName) = (false, false, false)
        let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]
        let contents = try FileManager.default.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: keys)

        for fileURL in contents {
            let attributes = try fileURL.resourceValues(forKeys: Set(keys))
            if attributes.name == "db" && attributes.isDirectory! == true {
                hasDB = true
            } else if attributes.name == "level.dat" && attributes.isDirectory! == false {
                hasLevelDat = true
            } else if attributes.name == "levelname.txt" && attributes.isDirectory! == false {
                hasLevelName = true
            }
        }

        if hasDB && hasLevelDat && hasLevelName { return true }
        return false
    }

//    public static var testWorld: MCDir {
//        return MCDir()
//    }
//
//    private init() {
//        self.dirURL = URL(fileURLWithPath: "./test")
//        self.useSecurityScope = false
//        self.worldName = "test world"
//        self.worldImage = nil
//    }

    public init(dirURL: URL, useSecurityScope: Bool, worldName: String, worldImage: CGImage?) {
        self.dirURL = dirURL
        self.useSecurityScope = useSecurityScope
        self.worldName = worldName
        self.worldImage = worldImage
    }

    public init(dirURL: URL, useSecurityScope: Bool) throws {
        let isMCDir = try Self.isMCWorldDir(dirURL: dirURL, useSecurityScope: useSecurityScope)
        if !isMCDir {
            throw CBLvDBError.invalidWorldDirectory(dirURL)
        }

        self.dirURL = dirURL
        self.useSecurityScope = useSecurityScope

        guard !useSecurityScope || dirURL.startAccessingSecurityScopedResource() else {
            throw CBLvDBError.invalidSecurityScope(dirURL)
        }
        defer {
            if useSecurityScope { dirURL.stopAccessingSecurityScopedResource() }
        }

        let levelNameFileURL = dirURL.appendingPathComponent("levelname.txt", isDirectory: false)
        if let fileData = try? Data(contentsOf: levelNameFileURL), let name = String(data: fileData, encoding: .utf8) {
            self.worldName = name
        }

        let imageURL = dirURL.appendingPathComponent("world_icon.jpeg", isDirectory: false)
        if let jpgImage = CGImage.loadJPG(url: imageURL) {
            self.worldImage = jpgImage
        }
    }

    public func move(to dstDir: URL, dstUseSecurityScope: Bool = true) throws -> MCDir {
        guard !useSecurityScope || dirURL.startAccessingSecurityScopedResource() else {
            throw CBLvDBError.invalidSecurityScope(dirURL)
        }
        guard !dstUseSecurityScope || dstDir.startAccessingSecurityScopedResource() else {
            throw CBLvDBError.invalidSecurityScope(dirURL)
        }
        defer {
            if useSecurityScope { dirURL.stopAccessingSecurityScopedResource() }
            if dstUseSecurityScope { dstDir.stopAccessingSecurityScopedResource() }
        }

        let dstURL = dstDir.appendingPathComponent(self.dirURL.lastPathComponent, isDirectory: true)
        try FileManager.default.moveItem(at: self.dirURL, to: dstURL)
        return MCDir(dirURL: dstURL, useSecurityScope: true, worldName: worldName, worldImage: worldImage)
    }

    public func copy(to dstDir: URL, dstUseSecurityScope: Bool = true, newDirName: String? = nil) throws -> MCDir {
        guard !useSecurityScope || dirURL.startAccessingSecurityScopedResource() else {
            throw CBLvDBError.invalidSecurityScope(dirURL)
        }
        guard !dstUseSecurityScope || dstDir.startAccessingSecurityScopedResource() else {
            throw CBLvDBError.invalidSecurityScope(dirURL)
        }
        defer {
            if useSecurityScope { dirURL.stopAccessingSecurityScopedResource() }
            if dstUseSecurityScope { dstDir.stopAccessingSecurityScopedResource() }
        }

        let oldName = dirURL.lastPathComponent
        let dstURL = dstDir.appendingPathComponent(newDirName ?? oldName, isDirectory: true)
        try FileManager.default.copyItem(at: dirURL, to: dstURL)
        return MCDir(dirURL: dstURL, useSecurityScope: false, worldName: worldName, worldImage: worldImage)
    }

    public func delete() throws {
        guard !useSecurityScope || dirURL.startAccessingSecurityScopedResource() else {
            throw CBLvDBError.invalidSecurityScope(dirURL)
        }
        defer {
            if useSecurityScope { dirURL.stopAccessingSecurityScopedResource() }
        }

        try FileManager.default.removeItem(at: dirURL)
    }

    public func parse() throws -> MCWorld {
        guard !useSecurityScope else {
            throw CBLvDBError.parsingWorldOutsideTheSandbox(dirURL)
        }
        return try MCWorld(from: dirURL)
    }
}
