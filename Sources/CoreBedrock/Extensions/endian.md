# Endian in Swift

## Dataにバイト列を渡す

Swiftはデフォルトで**リトルエンディアン**でデータを扱う
```swift
Data( [0x11, 0x22, 0x33, 0x44] )

// Little Endian(内部値): 0x11, 0x22, 0x33, 0x44
```

## Dataから数値に変換する

```swift
let data = Data( [0x11, 0x22, 0x33, 0x44] )
let num: Int32 = Int32(littleEndian: data.withUnsafeBytes{
    $0.load(as: Int32.self)
})

// Little Endian(内部値): 0x11, 0x22, 0x33, 0x44
```
