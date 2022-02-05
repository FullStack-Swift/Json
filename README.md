# Json

A description of this package.
```swift
let json = "".toJson()
let json = data.toJson()
let json = dictionary.toJson()
let json = model.toJson()
```

```swift
let data = json.toData()
let string = json.toString()
let dictionary = json.toDictionary()
let model = json.toModel(Model.self)
```


# Installation

## Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/FullStack-Swift/Json", .upToNextMajor(from: "1.0.0"))
]
```
