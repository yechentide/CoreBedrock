# 0x3A RandomTicks

## Key

```txt
[chunkX][chunkZ][dimension?][0x3A]
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

Block states related to random ticks, such as fire.
