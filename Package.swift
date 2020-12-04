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
      name: "MLIRDialect",
      targets: ["MLIRDialect"]),
    .library(
      name: "MLIRStandard",
      targets: ["MLIRStandard"]),
  ],
  targets: [
    .systemLibrary(
      name: "CMLIR",
      pkgConfig: "MLIR"),
    .target(
      name: "MLIRDialect",
      dependencies: ["CMLIR"]),
    .target(
      name: "MLIR",
      dependencies: ["MLIRDialect", "CMLIR"]),
    .testTarget(
      name: "MLIRTests",
      dependencies: ["MLIR"]),
    
    .systemLibrary(
      name: "CMLIRStandard",
      pkgConfig: "MLIR"),
    .target(
      name: "MLIRStandard",
      dependencies: ["CMLIRStandard", "MLIR"]),
    .testTarget(
      name: "MLIRStandardTests",
      dependencies: ["MLIRStandard"]),
  ]
)
