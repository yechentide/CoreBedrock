# Map Keys

## Key

```txt
map_<id>
```

`id` is a decimal string.

## Value

Little-endian NBT compound.

Representative fields:

- `colors`: 65536 bytes
- `decorations`
- `dimension`
- `fullyExplored`
- `height`, `width`
- `mapId`
- `mapLocked`
- `parentMapId`
- `scale`
- `unlimitedTracking`
- `xCenter`, `zCenter`

## Reading Notes

`colors` is 128x128 map pixel data. Map items contain fields such as `map_uuid` and `map_name_index`, which refer to the corresponding `map_<id>` record.
