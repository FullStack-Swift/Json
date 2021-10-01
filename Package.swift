  // swift-tools-version:5.5
  // The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Json",
  products: [
    .library(
      name: "Json",
      targets: ["Json"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
    .package(url: "https://github.com/Quick/Nimble.git", from: "9.2.0"),
  ],
  targets: [
    .target(
      name: "Json",
      dependencies: []),
    .testTarget(
      name: "JsonTests",
      dependencies: ["Json", "Quick", "Nimble"]),
  ]
)
