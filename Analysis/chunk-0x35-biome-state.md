# 0x35 BiomeState

## Key

```txt
[chunkX][chunkZ][dimension?][0x35]
```

## Value

Treat as little-endian NBT.

## Confirmed Facts

- Exists as a key type.
- Local notes identify it as `biomeState`, but the value layout is not yet analyzed.
- `0x2B Data3D` contains the 1.18+ 3D biome map payload.

## Reading Policy

- Read `0x2B Data3D` first for biome reconstruction.
- Preserve `0x35` as unknown NBT and avoid editing or deleting it.
- Try reading it as little-endian NBT; keep raw data if parsing fails.
