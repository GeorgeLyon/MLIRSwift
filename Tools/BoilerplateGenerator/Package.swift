// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "BoilerplateGenerator",
  products: [
    .executable(
      name: "GenerateTypedOperationInitializers",
      targets: ["GenerateTypedOperationInitializers"]),
    .executable(
      name: "GenerateBlockConvenienceInitializers",
      targets: ["GenerateBlockConvenienceInitializers"]),
    .executable(
      name: "GenerateBlockOperationsAppend",
      targets: ["GenerateBlockOperationsAppend"]),
  ],
  targets: [
    .target(name: "Utilities"),
    .target(name: "GenerateTypedOperationInitializers", dependencies: ["Utilities"]),
    .target(name: "GenerateBlockConvenienceInitializers", dependencies: ["Utilities"]),
    .target(name: "GenerateBlockOperationsAppend", dependencies: ["Utilities"]),
  ]
)
