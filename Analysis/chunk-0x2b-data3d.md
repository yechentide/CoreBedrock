# 0x2B Data3D

## Key

```txt
[chunkX][chunkZ][dimension?][0x2B]
```

This is a chunk-level key and does not include `subChunkY`.

## Value

In 1.18+ samples, this value contains 3D biome data.

```txt
[heightmap: 512 bytes]
[biome section 1]
[biome section 2]
...
```

The heightmap appears to be `16 * 16 * UInt16 LE`.

## Biome Section

Based on local analysis and public information, the following layout is a practical read model.

```txt
[header: UInt8]
if header == 0xFF:
  section absent
else if header == 0x01:
  [biomeId: UInt32 LE]
else:
  [packed palette indices]
  [paletteLength: UInt32 LE]
  [biomeId: UInt32 LE] * paletteLength
```

- Bit 0 of `header` appears to always be `1`.
- Bits `7...1` are the bits per value.
- The packed array uses the same aligned bit-packed Int32 style as the SubChunk block palette.
- Block/biome index order is sometimes described as XZY. This document uses `(x * 16 + z) * 16 + y`.

## Local Samples

- `01 BE 00 00 00`: single biome `0xBE = 190 = deep_dark`
- `01 23 00 00 00`: single biome `0x23 = 35 = savanna`
- `03 ... 02 00 00 00 ...`: 1-bit index, palette length 2.
- `FF`: absent section.
