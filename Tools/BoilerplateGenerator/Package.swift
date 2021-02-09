// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "BoilerplateGenerator",
  products: [
    .executable(
      name: "GenerateOperationDefinitionInitializers",
      targets: ["GenerateOperationDefinitionInitializers"]),
    .executable(
      name: "GenerateBlockOperationsAppend",
      targets: ["GenerateBlockOperationsAppend"]),
  ],
  targets: [
    .target(name: "Utilities"),
    .target(name: "GenerateOperationDefinitionInitializers", dependencies: ["Utilities"]),
    .target(name: "GenerateBlockOperationsAppend", dependencies: ["Utilities"]),
  ]
)
