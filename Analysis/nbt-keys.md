# NBT Key Summary

Summary of keys whose values are read as NBT. Bedrock LevelDB uses a little-endian NBT variant, so Java Edition big-endian NBT parsers cannot be used as-is.

## Chunk NBT Key

| Key type | File | NBT root |
|---|---|---|
| `0x31 blockEntity` | `chunk-0x31-block-entity.md` | Concatenated compound roots. |
| `0x33 pendingTicks` | `chunk-0x33-pending-ticks.md` | Usually a compound. |
| `0x35 biomeState` | `chunk-0x35-biome-state.md` | Treated as NBT; layout is not fully analyzed. |
| `0x3A randomTicks` | `chunk-0x3a-random-ticks.md` | Usually a compound. |

Notes:

- `0x32 entity` is legacy entity data. When needed, try reading it as a little-endian NBT compound list.

## String NBT Key

| String key | Description |
|---|---|
| `~local_player` | Local player entity compound. |
| `AutonomousEntities` | `AutonomousEntityList`. |
| `BiomeData` | Snow accumulation and related biome data. |
| `LevelChunkMetaDataDictionary` | Header-prefixed NBT. Contains height range, base game version, migration flags, and related metadata. |
| `mobevents` | Dragon, patrol, and wandering trader event flags. |
| `Overworld` | Dimension data and `LimboEntities`. |
| `Nether` | Dimension data and `LimboEntities`. |
| `TheEnd` | Dimension data, `DragonFight`, and `LimboEntities`. |
| `portals` | Portal records. |
| `schedulerWT` | Wandering trader scheduler. |
| `scoreboard` | Scoreboard lists. |

Notes:

- `Overworld`, `Nether`, `TheEnd`, and `portals` are read as little-endian NBT compounds.
- `LevelChunkMetaDataDictionary` has header bytes before the NBT payload. In one sample, the compound follows `06 00 00 00 7c b9 b1 07 e0 3c 70 05`.

## Prefix / Special NBT Key

| Key group | Key form | Description |
|---|---|---|
| player key | `player_<id>` / `player_<type>_<id>` | Remote/server player data. |
| map key | `map_<id>` | Map colors, center coordinates, scale, and related data. |
| village key | `VILLAGE_<dimension>_<id>_<type>` / `VILLAGE_<id>_<type>` | Dwellers, info, players, and POI data. The dimensionless form is legacy Overworld data. |
| structure key | `structuretemplate_mystructure:<name>` | Structure template. |
| actor key | `actorprefix<actor-storage-key>` | Actor entity compound. |
