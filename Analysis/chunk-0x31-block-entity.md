# 0x31 BlockEntity

## Key

```txt
[chunkX][chunkZ][dimension?][0x31]
```

## Value

Little-endian NBT. The value is read as concatenated compound roots.

## Local Samples

Confirmed:

- Chest
  - `LootTable`
  - `Items`
  - `x`, `y`, `z`
- MobSpawner
  - `EntityIdentifier`
  - `Delay`
  - `MinSpawnDelay`, `MaxSpawnDelay`
  - `SpawnCount`, `SpawnRange`

## Reading Notes

Block entities are tied to block positions inside the chunk. Indexing them by `x`, `y`, and `z` makes lookup straightforward.
