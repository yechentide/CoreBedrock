# 0x33 PendingTicks

## Key

```txt
[chunkX][chunkZ][dimension?][0x33]
```

## Value

Little-endian NBT.

Local samples have a root compound with:

- `currentTick`
- `tickList`
  - `blockState`
  - `time`
  - `x`, `y`, `z`

## Contents

Block states with scheduled ticks, such as water and lava flow updates.

## Reading Notes

`blockState` is a compound with `name`, `states`, and `version`. It can be handled with the same block state representation used by SubChunk block palettes.
