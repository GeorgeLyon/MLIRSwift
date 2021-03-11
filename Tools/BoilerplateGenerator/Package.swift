// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "BoilerplateGenerator",
  products: [
    .executable(
      name: "GenerateOperationExtensions",
      targets: ["GenerateOperationExtensions"]),
    .executable(
      name: "GenerateBlockInitializers",
      targets: ["GenerateBlockInitializers"]),
    .executable(
      name: "GenerateBlockOperationsAppend",
      targets: ["GenerateBlockOperationsAppend"]),
  ],
  targets: [
    .target(name: "Utilities"),
    .target(name: "GenerateOperationExtensions", dependencies: ["Utilities"]),
    .target(name: "GenerateBlockInitializers", dependencies: ["Utilities"]),
    .target(name: "GenerateBlockOperationsAppend", dependencies: ["Utilities"]),
  ]
)
