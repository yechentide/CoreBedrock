# String Key Types

Fixed string keys.

## NBT Keys

See `nbt-keys.md` for the combined NBT key summary.

| Case | Raw key | Description |
|---|---|---|
| `autonomousEntities` | `AutonomousEntities` | `AutonomousEntityList`. |
| `biomeData` | `BiomeData` | Snow accumulation and related biome data. |
| `levelChunkMetaDataDictionary` | `LevelChunkMetaDataDictionary` | Header-prefixed NBT. Contains height range, base game version, generation seed, and related metadata. |
| `mobevents` | `mobevents` | Dragon, patrol, and trader event flags. |
| `overworld` | `Overworld` | Dimension data and `LimboEntities`. |
| `nether` | `Nether` | Dimension data and `LimboEntities`. |
| `theEnd` | `TheEnd` | Dimension data including `DragonFight`. |
| `portals` | `portals` | Portal records. |
| `schedulerWT` | `schedulerWT` | Wandering trader scheduler. |
| `scoreboard` | `scoreboard` | Scoreboard data. |
| `localPlayer` | `~local_player` | Local player entity. |

## Other Keys

| Case | Raw key | Description |
|---|---|---|
| `dimension0` | `dimension0` | Not yet analyzed. |

## Legacy

| Case | Raw key | Description |
|---|---|---|
| `flatworldlayers` | `game_flatworldlayers` | Flat world info before 1.5. This is now stored in `level.dat`. |
| `mVillages` | `mVillages` | Old village info before 1.11. |
| `legacyVillages` | `villages` | Legacy village data. |

## Reading Notes

Fixed string keys can be identified by exact UTF-8 string matching.

`LevelChunkMetaDataDictionary` has header bytes before the NBT payload, so it is not read from the same offset as ordinary NBT keys.
