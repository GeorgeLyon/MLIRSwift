// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "BoilerplateGenerator",
  products: [
    .executable(name: "GenerateTypeList", targets: ["GenerateTypeList"]),
    .executable(name: "GenerateArrayStringsHelper", targets: ["GenerateArrayStringsHelper"]),
  ],
  targets: [
    .target(name: "GenerateTypeList"),
    .target(name: "GenerateArrayStringsHelper"),
  ]
)
