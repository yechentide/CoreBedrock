# 0x40 BlendingData

## Key

```txt
[chunkX][chunkZ][dimension?][0x40]
```

## Value

Local notes:

- 2-byte number
- Around Bedrock 1.19: `0x0003`

## Reading Policy

Try reading as `UInt16 LE`. Preserve raw data for unknown values.
