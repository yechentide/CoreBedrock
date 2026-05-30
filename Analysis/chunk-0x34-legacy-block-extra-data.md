# 0x34 LegacyBlockExtraData

## Key

```txt
[chunkX][chunkZ][dimension?][0x34]
```

## Value

Old extra block data.

Public information describes:

```txt
[entryCount: UInt32 LE]
[
  [key: UInt32 LE]
  [value: UInt16 LE]
] * entryCount
```

## Purpose

This older format represented overlapping blocks at the same position, such as grass inside a snow layer.

## Status

Since 1.2.13, this appears to have been replaced by multiple storages in SubChunk records.
