// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "BoilerplateGenerator",
  products: [
    .executable(name: "GenerateBlockInitializers", targets: ["GenerateBlockInitializers"]),
    .executable(name: "GenerateGenericOperationBuilders", targets: ["GenerateGenericOperationBuilders"]),
    .executable(name: "GenerateTypeListImplementation", targets: ["GenerateTypeListImplementation"]),
  ],
  targets: [
    .target(name: "Utilities"),
    .target(name: "GenerateBlockInitializers", dependencies: ["Utilities"]),
    .target(name: "GenerateGenericOperationBuilders", dependencies: ["Utilities"]),
    .target(name: "GenerateTypeListImplementation", dependencies: ["Utilities"]),
  ]
)
