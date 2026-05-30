# Digp Keys

## Key

```txt
"digp" + [chunkX: Int32 LE] + [chunkZ: Int32 LE] + [dimension?: Int32 LE]
```

- The dimension is omitted for the Overworld.
- Nether is `1`, End is `2`.

## Value

Not NBT.

```txt
[actor storage key: 8 bytes] * N
```

## Reading Notes

Split the value into 8-byte actor storage keys. Use each as the suffix for `actorprefix<actor-storage-key>` to fetch the actor NBT payload.

If the value size is not a multiple of 8, treat it as corrupt data or an unknown format.
