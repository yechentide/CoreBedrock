# Village Keys

## Key

```txt
VILLAGE_<dimension>_<id>_<type>
VILLAGE_<id>_<type>
```

Examples:

```txt
VILLAGE_Overworld_<id>_DWELLERS
VILLAGE_Overworld_<id>_INFO
VILLAGE_Overworld_<id>_PLAYERS
VILLAGE_Overworld_<id>_POI
VILLAGE_<id>_INFO
```

## Value

Little-endian NBT compound.

## Key Parts

- `VILLAGE_` is a fixed prefix.
- `dimension` is a dimension name such as `Overworld`.
- `id` is the village identifier.
- `type` is one of values such as `DWELLERS`, `INFO`, `PLAYERS`, or `POI`.

## Legacy Overworld Format

Some older data omits the `Overworld` dimension segment:

```txt
VILLAGE_<id>_<type>
```

Treat this as an Overworld village key. When writing or normalizing the key, use the explicit current form:

```txt
VILLAGE_Overworld_<id>_<type>
```

## Known Suffixes

- `_DWELLERS`: villager / mob actor IDs and last saved positions.
- `_INFO`: village bounding box, tick, and version data.
- `_PLAYERS`: players that interacted with the village.
- `_POI`: villagers and POI instances.

## `_DWELLERS`

Stores villagers and related actors that belong to the village.

Representative fields:

- `Dwellers`
- `actors`
- `ID`
- `TS`
- `last_saved_pos`

## `_INFO`

Stores the village bounds and tick state.

Representative fields:

- `X0`, `X1`, `Y0`, `Y1`, `Z0`, `Z1`
- `RX0`, `RX1`, `RY0`, `RY1`, `RZ0`, `RZ1`
- `Tick`
- `Version`
- `Initialized`

## `_PLAYERS`

Stores players that interacted with the village.

Representative fields:

- `Players`
- `ID`
- `S`

## `_POI`

Stores villagers and POI instances.

Representative fields:

- `POI`
- `VillagerID`
- `instances`
- `Capacity`
- `Name`
- `OwnerCount`
- `Radius`
- `Type`
- `X`, `Y`, `Z`
