# 0x2F SubChunkPrefix

## Key

```txt
[chunkX][chunkZ][dimension?][0x2F][subChunkY: Int8]
```

Terrain block data. Stored per 16x16x16 subchunk.

## Value

### Version 8

```txt
[version: UInt8]
[numStorages: UInt8]
[block storage 1]
...
[block storage N]
```

- Paletted format from Update Aquatic onward.
- The `subChunkY` key suffix identifies the subchunk Y index.
- When `numStorages > 1`, the second layer is commonly a water layer.

### Version 9

```txt
[version: UInt8]
[numStorages: UInt8]
[subChunkY: Int8]
[block storage 1]
...
[block storage N]
```

- Used after the 1.18 height extension.
- The value also contains `subChunkY`.
- When `numStorages > 1`, the second layer is commonly a water layer.

### Block Storage

```txt
[storageHeader: UInt8]
[packed palette indices]
[palette count]
[palette NBT compound entries]
```

`storageHeader`:

- Bit 0: palette type. Persisted data uses the persistent palette.
- Bits `7...1`: bits per palette index.

Valid bits per index:

| Bits | Blocks per UInt32 | Notes |
|---:|---:|---|
| 1 | 32 | |
| 2 | 16 | |
| 3 | 10 | 2 bits of padding |
| 4 | 8 | |
| 5 | 6 | 2 bits of padding |
| 6 | 5 | 2 bits of padding |
| 8 | 4 | |
| 16 | 2 | |

### Index Order

Use this index formula:

```txt
index = (localX * 16 + localZ) * 16 + localY
```

Y increments first, then Z, then X. Public references sometimes call this YZX order.

## Notes

Runtime IDs are session-dependent and should not be used as persisted identifiers. Read persisted palette entries as block state NBT.
