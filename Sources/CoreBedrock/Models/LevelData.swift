import Foundation

public struct LevelData: CustomStringConvertible {
    private let srcURL: URL
    private var version: Int32
    public var rootTag: CompoundTag
    
    public init(srcURL: URL) throws {
        guard let nbtData = try? Data(contentsOf: srcURL), nbtData.count > 8 else {
            throw CBLvDBError.failedParseLevelData(srcURL)
        }
        
        version = nbtData[0...3].int32!
        // data length: nbtData[4...7].int32
        
        let stream = CBBuffer(nbtData[8...])
        let reader = CBReader(stream)
        rootTag = try reader.readAsTag() as! CompoundTag
        if rootTag.tagType != .compound { throw CBLvDBError.failedParseLevelData(srcURL) }
        
        self.srcURL = srcURL
    }
    
    public var description: String {
        return "Version: \(version)\nContent:\n\(rootTag.description)"
    }
    
    public func saveChanges() {
        do {
            try FileManager.default.removeItem(at: srcURL)
            save(to: srcURL)
        } catch {
            print(error)
        }
    }
    
    public func save(to dstURL: URL) {
        do {
            let ms = CBBuffer()
            let writer = try CBWriter(stream: ms, rootTagName: "")
            
            for tag in rootTag {
                try writer.writeTag(tag: tag)
            }
            
            try writer.endCompound()
            try writer.finish()
            
            let contentData = Data(ms.toArray())
            let data = version.data + Int32(contentData.count).data + contentData
            try data.write(to: dstURL)
        } catch {
            fatalError("Error: faild save")
        }
    }
}

extension LevelData {
    public var worldName: String {
        get {
            return rootTag["LevelName"]?.stringValue ?? ""
        }
        set {
            rootTag["LevelName"] = StringTag(name: "LevelName", newValue)
            let nameFileURL = srcURL.deletingLastPathComponent().appendingPathComponent("levelname.txt")
            try? newValue.write(to: nameFileURL, atomically: true, encoding: .utf8)
        }
    }
    
    public var difficulty: Int32 {
        get {
            return rootTag["Difficulty"]?.intValue ?? 0
        }
        set {
            rootTag["Difficulty"] = IntTag(name: "Difficulty", newValue)
        }
    }
    
    public var inventoryVersion: String {
        return rootTag["InventoryVersion"]?.stringValue ?? ""
    }
    
    public var RandomSeed: Double {
        return rootTag["RandomSeed"]?.doubleValue ?? 0.0
    }
    
    public var spawnX: Int32 {
        return rootTag["SpawnX"]?.intValue ?? 0
    }
    
    public var spawnY: Int32 {
        return rootTag["SpawnY"]?.intValue ?? 0
    }

    public var spawnZ: Int32 {
        return rootTag["SpawnZ"]?.intValue ?? 0
    }
}

extension LevelData {
    public var commandsEnabled: UInt8 {
        get {
            return rootTag["commandsEnabled"]?.byteValue ?? 0
        }
        set {
            rootTag["commandsEnabled"] = ByteTag(name: "commandsEnabled", newValue)
        }
    }
    
    public var commandblockoutput: UInt8 {
        get {
            return rootTag["commandblockoutput"]?.byteValue ?? 0
        }
        set {
            rootTag["commandblockoutput"] = ByteTag(name: "commandblockoutput", newValue)
        }
    }
    
    public var commandblocksenabled: UInt8 {
        get {
            return rootTag["commandblocksenabled"]?.byteValue ?? 0
        }
        set {
            rootTag["commandblocksenabled"] = ByteTag(name: "commandblocksenabled", newValue)
        }
    }
    
    public var dodaylightcycle: UInt8 {
        get {
            return rootTag["dodaylightcycle"]?.byteValue ?? 0
        }
        set {
            rootTag["dodaylightcycle"] = ByteTag(name: "dodaylightcycle", newValue)
        }
    }
    
    public var doentitydrops: UInt8 {
        get {
            return rootTag["doentitydrops"]?.byteValue ?? 0
        }
        set {
            rootTag["doentitydrops"] = ByteTag(name: "doentitydrops", newValue)
        }
    }
    
    public var dofiretick: UInt8 {
        get {
            return rootTag["dofiretick"]?.byteValue ?? 0
        }
        set {
            rootTag["dofiretick"] = ByteTag(name: "dofiretick", newValue)
        }
    }
    
    public var domobloot: UInt8 {
        get {
            return rootTag["domobloot"]?.byteValue ?? 0
        }
        set {
            rootTag["domobloot"] = ByteTag(name: "domobloot", newValue)
        }
    }
    
    public var domobspawning: UInt8 {
        get {
            return rootTag["domobspawning"]?.byteValue ?? 0
        }
        set {
            rootTag["domobspawning"] = ByteTag(name: "domobspawning", newValue)
        }
    }
    
    public var dotiledrops: UInt8 {
        get {
            return rootTag["dotiledrops"]?.byteValue ?? 0
        }
        set {
            rootTag["dotiledrops"] = ByteTag(name: "dotiledrops", newValue)
        }
    }
    
    public var doweathercycle: UInt8 {
        get {
            return rootTag["doweathercycle"]?.byteValue ?? 0
        }
        set {
            rootTag["doweathercycle"] = ByteTag(name: "doweathercycle", newValue)
        }
    }
    
    public var drowningdamage: UInt8 {
        get {
            return rootTag["drowningdamage"]?.byteValue ?? 0
        }
        set {
            rootTag["drowningdamage"] = ByteTag(name: "drowningdamage", newValue)
        }
    }
    
    public var falldamage: UInt8 {
        get {
            return rootTag["falldamage"]?.byteValue ?? 0
        }
        set {
            rootTag["falldamage"] = ByteTag(name: "falldamage", newValue)
        }
    }
    
    public var firedamage: UInt8 {
        get {
            return rootTag["firedamage"]?.byteValue ?? 0
        }
        set {
            rootTag["firedamage"] = ByteTag(name: "firedamage", newValue)
        }
    }
    
    public var freezedamage: UInt8 {
        get {
            return rootTag["freezedamage"]?.byteValue ?? 0
        }
        set {
            rootTag["freezedamage"] = ByteTag(name: "freezedamage", newValue)
        }
    }
    
    public var hasBeenLoadedInCreative: UInt8 {
        get {
            return rootTag["hasBeenLoadedInCreative"]?.byteValue ?? 0
        }
        set {
            rootTag["hasBeenLoadedInCreative"] = ByteTag(name: "hasBeenLoadedInCreative", newValue)
        }
    }
    
    public var pvp: UInt8 {
        get {
            return rootTag["pvp"]?.byteValue ?? 0
        }
        set {
            rootTag["pvp"] = ByteTag(name: "pvp", newValue)
        }
    }
    
    public var showcoordinates: UInt8 {
        get {
            return rootTag["showcoordinates"]?.byteValue ?? 0
        }
        set {
            rootTag["showcoordinates"] = ByteTag(name: "showcoordinates", newValue)
        }
    }
    
    public var spawnMobs: UInt8 {
        get {
            return rootTag["spawnMobs"]?.byteValue ?? 0
        }
        set {
            rootTag["spawnMobs"] = ByteTag(name: "spawnMobs", newValue)
        }
    }
    
    public var tntexplodes: UInt8 {
        get {
            return rootTag["tntexplodes"]?.byteValue ?? 0
        }
        set {
            rootTag["tntexplodes"] = ByteTag(name: "tntexplodes", newValue)
        }
    }
}
