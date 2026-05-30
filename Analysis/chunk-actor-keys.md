# Actorprefix Keys

## Key

```txt
actorprefix<actor-storage-key>
```

## Value

Little-endian NBT compound. Actor entity data.

Representative fields:

- `identifier`
- `UniqueID`
- `Pos`, `Rotation`, `Motion`
- Flags such as `IsBaby`, `OnGround`, and `Sitting`
- `definitions`
- `internalComponents.EntityStorageKeyComponent.StorageKey`

## Relationship With digp

Split the `digp` value into 8-byte actor storage keys. Prefix each storage key with `actorprefix` to fetch the actor NBT payload.
