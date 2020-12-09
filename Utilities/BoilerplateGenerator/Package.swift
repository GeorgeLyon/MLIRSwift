// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "BoilerplateGenerator",
  products: [
    .executable(name: "GenerateBlockInitializers", targets: ["GenerateBlockInitializers"]),
    .executable(name: "GenerateOperationProtocolExtensions", targets: ["GenerateOperationProtocolExtensions"]),
    .executable(name: "GenerateArrayStringsHelper", targets: ["GenerateArrayStringsHelper"]),
  ],
  targets: [
    .target(name: "Utilities"),
    .target(name: "GenerateBlockInitializers", dependencies: ["Utilities"]),
    .target(name: "GenerateOperationProtocolExtensions", dependencies: ["Utilities"]),
    .target(name: "GenerateArrayStringsHelper", dependencies: ["Utilities"]),
  ]
)
