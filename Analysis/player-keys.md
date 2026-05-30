# Player Keys

Player keys are prefix keys that store remote/server player data.

## Key

```txt
player_<id>
player_<type>_<id>
```

Examples:

```txt
player_<id>
player_server_<id>
```

`~local_player` is a fixed string key. See `string-keys.md` and `nbt-keys.md`.

## Key Parts

- `player_` is a fixed prefix.
- `id` is the player identifier.
- `type`, when present, is a player data type such as `server`.

## Value

Little-endian NBT compound.

Representative fields:

- `Pos`, `Rotation`, `DimensionId`
- `Inventory`, `Armor`, `EnderChestInventory`
- `Attributes`
- `PlayerGameMode`, `PlayerLevel`, `PlayerLevelProgress`
- `abilities`
- `permissionsLevel`, `playerPermissionsLevel`
- `UniqueID`
- `internalComponents.EntityStorageKeyComponent.StorageKey`

## Reading Notes

Player data is shaped similarly to an entity compound, but the local player is stored directly under `~local_player`. Remote/server players are found through the prefixed player keys.
