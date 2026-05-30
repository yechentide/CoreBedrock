# 0x30 LegacyTerrain

## Key

```txt
[chunkX][chunkZ][dimension?][0x30]
```

## Value

Old full-chunk terrain data.

Public information describes:

- Block IDs
- Block metadata nibble array
- Sky light nibble array
- Block light nibble array
- Heightmap
- 2D biome data

## Status

Since Pocket Edition 1.0.0, terrain is split into `0x2F SubChunkPrefix` records. This is a legacy fallback for current worlds.
