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
    .library(
      name: "MLIRDialects",
      targets: ["MLIRDialects"]),
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
    
    .systemLibrary(
      name: "CMLIRDialects",
      pkgConfig: "MLIR"),
    .target(
      name: "MLIRDialects",
      dependencies: ["CMLIRDialects", "MLIR"]),
    .testTarget(
      name: "MLIRDialectsTests",
      dependencies: ["MLIRDialects"]),
  ]
)
