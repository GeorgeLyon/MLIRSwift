// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "MLIR",
  platforms: [
    .macOS(.v11),
  ],
  products: [
    .library(
      name: "MLIR",
      targets: ["MLIR"]),
  ],
  dependencies: [
  ],
  targets: [
    .systemLibrary(
      name: "CMLIR",
      pkgConfig: "MLIR"),
    .target(
      name: "MLIR",
      dependencies: ["CMLIR"]),
    .testTarget(
      name: "MLIRTests",
      dependencies: ["MLIR"]),
  ]
)
