# 0x2E LegacyData2D

## Key

```txt
[chunkX][chunkZ][dimension?][0x2E]
```

## Value

Old 2D biome/elevation data.

Public information describes:

- Heightmap: `256 * UInt16`
- 2D biome entries in a format resembling biome ID + RGB
- Usually not written since 1.0.0.

## Reading Notes

This is normally not read for current data. Treat it as a fallback for old world conversion.
