//
// Created by yechentide on 2024/07/14
//

import Foundation

/// Represents a Minecraft Bedrock Edition world with its directory, database, and metadata.
///
/// `MCWorld` provides access to world data stored in LevelDB format. The database can be
/// injected for testing or alternative storage implementations.
///
/// ## Topics
///
/// ### Creating a World
/// - ``init(from:meta:)``
/// - ``init(from:database:meta:)``
///
/// ### Accessing World Data
/// - ``dirURL``
/// - ``database``
/// - ``worldName``
/// - ``meta``
///
/// ### Managing the Database
/// - ``closeDB()``
/// - ``reloadMetaFile()``
///
/// ## Usage
///
/// ### Opening a World
/// ```swift
/// let worldURL = URL(fileURLWithPath: "/path/to/world")
/// let world = try MCWorld(from: worldURL)
/// defer { world.closeDB() }
/// ```
///
/// ### Injecting a Custom Database
/// Useful for testing, SwiftUI Previews, or custom storage backends:
/// ```swift
/// let mockDB: LevelKeyValueStore = MockDatabase()
/// let world = try MCWorld(from: worldURL, database: mockDB)
/// ```
public class MCWorld {
    /// The directory URL containing the world files.
    public let dirURL: URL

    /// The key-value store used to access world data.
    ///
    /// This property allows injecting custom database implementations for testing
    /// or alternative storage backends. By default, it uses `LvDB` from `LvDBWrapper`.
    public let database: LevelKeyValueStore

    /// The display name of the world, extracted from metadata.
    public var worldName = "???"

    /// The world's metadata, typically loaded from `level.dat`.
    public var meta: MCWorldMeta

    /// Creates a new `MCWorld` instance by opening the database at the specified directory.
    ///
    /// This convenience initializer opens an `LvDB` instance and forwards to the designated initializer.
    ///
    /// - Parameters:
    ///   - dirURL: The directory URL containing the world files.
    ///   - meta: Optional pre-loaded metadata. If `nil`, metadata will be loaded from `level.dat`.
    /// - Throws: An error if the database cannot be opened or metadata cannot be loaded.
    public convenience init(from dirURL: URL, meta: MCWorldMeta? = nil) throws {
        let dbPath = MCDir.generatePath(for: .db, in: dirURL)
        let db: LevelKeyValueStore
        do {
            db = try LevelKeyValueStoreFactory.makeDefault(dbPath: dbPath, createIfMissing: false)
        } catch let nsError as NSError {
            throw LvDBError(nsError: nsError)
        }

        try self.init(from: dirURL, database: db, meta: meta)
    }

    /// Creates a new `MCWorld` instance with an injected database.
    ///
    /// This designated initializer allows dependency injection of the database, enabling:
    /// - **Testing**: Use in-memory or mock databases
    /// - **SwiftUI Previews**: Provide sample data without file I/O
    /// - **Custom Storage**: Implement cloud-backed or alternative storage backends
    ///
    /// - Parameters:
    ///   - dirURL: The directory URL containing the world files.
    ///   - database: The key-value store to use for world data access.
    ///   - meta: Optional pre-loaded metadata. If `nil`, metadata will be loaded from `level.dat`.
    /// - Throws: An error if metadata cannot be loaded.
    public init(from dirURL: URL, database: LevelKeyValueStore, meta: MCWorldMeta? = nil) throws {
        self.dirURL = dirURL
        self.database = database

        if let metaArg = meta {
            self.meta = metaArg
        } else {
            let levelDatURL = MCDir.generateURL(for: .levelDat, in: dirURL)
            self.meta = try MCWorldMeta(from: levelDatURL)
        }
        if let name = self.meta.worldName {
            self.worldName = name
        }
    }

    /// Closes the database and releases associated resources.
    ///
    /// After calling this method, no further database operations should be performed on this world.
    /// All active iterators will also be destroyed.
    public func closeDB() {
        self.database.close()
    }

    /// Reloads the world metadata from the `level.dat` file.
    ///
    /// - Throws: An error if the metadata file cannot be read or parsed.
    public func reloadMetaFile() throws {
        let levelDatURL = MCDir.generateURL(for: .levelDat, in: self.dirURL)
        self.meta = try MCWorldMeta(from: levelDatURL)
    }
}
