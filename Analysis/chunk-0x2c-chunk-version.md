# 0x2C ChunkVersion

## Key

```txt
[chunkX][chunkZ][dimension?][0x2C]
```

## Value

One-byte version value.

Local notes:

- Around Bedrock 1.19: `0x28`
- Server-saved data: `0x27`

## Purpose

This chunk version record was moved forward for the extended heights feature. Older chunks may not have this record.

## Reading Notes

- Useful for chunk existence checks.
- Checking `0x76 legacyChunkVersion` as a fallback improves compatibility with older worlds.
