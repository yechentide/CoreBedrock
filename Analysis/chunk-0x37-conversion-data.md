# 0x37 ConversionData

## Key

```txt
[chunkX][chunkZ][dimension?][0x37]
```

## Value

Local note:

> data that the converter provides, that are used at runtime for things like blending

## Reading Policy

Preserve as unanalyzed raw data. Do not casually decide whether to keep or delete it during chunk deletion or regeneration tooling.
