# Chunk Key Format

Bedrock Edition LevelDB chunk keys consist of chunk coordinates, an optional dimension, a key type, and an optional subchunk Y index.

## Overworld

```txt
[chunkX: Int32 LE][chunkZ: Int32 LE][type: UInt8][subChunkY: Int8?]
```

## Nether / End

```txt
[chunkX: Int32 LE][chunkZ: Int32 LE][dimension: Int32 LE][type: UInt8][subChunkY: Int8?]
```

- `dimension` is omitted for the Overworld.
- Nether is `1`.
- End is `2`.
- `subChunkY` is mainly present for `0x2F SubChunkPrefix`.
- Since 1.18, the Overworld height range is `-64...319`, so `subChunkY` can be `-4...19`.

## Chunk Type Files

- `chunk-0x2b-data3d.md`
- `chunk-0x2c-chunk-version.md`
- `chunk-0x2d-data2d.md`
- `chunk-0x2e-legacy-data2d.md`
- `chunk-0x2f-prefix.md`
- `chunk-0x30-legacy-terrain.md`
- `chunk-0x31-block-entity.md`
- `chunk-0x32-entity.md`
- `chunk-0x33-pending-ticks.md`
- `chunk-0x34-legacy-block-extra-data.md`
- `chunk-0x35-biome-state.md`
- `chunk-0x36-finalized-state.md`
- `chunk-0x37-conversion-data.md`
- `chunk-0x38-border-blocks.md`
- `chunk-0x39-hardcoded-spawners.md`
- `chunk-0x3a-random-ticks.md`
- `chunk-0x3b-checksums.md`
- `chunk-0x3c-generation-seed.md`
- `chunk-0x3d-generated-pre-caves-and-cliffs-blending.md`
- `chunk-0x3e-blending-biome-height.md`
- `chunk-0x3f-meta-data-hash.md`
- `chunk-0x40-blending-data.md`
- `chunk-0x41-actor-digest-version.md`
- `chunk-0x76-legacy-chunk-version.md`
- `chunk-0x77-aabb-volumes.md`

## String / Prefix Key Files

- `string-keys.md`
- `player-keys.md`
- `map-keys.md`
- `village-keys.md`
- `structure-keys.md`
- `chunk-actor-keys.md`
- `chunk-digp-keys.md`
- `realms-story-keys.md`
- `nbt-keys.md`
