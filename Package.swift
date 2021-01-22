// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "MLIR",
  platforms: [
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "MLIR",
      targets: ["MLIR"]),
    .library(
      name: "MLIRStandard",
      targets: ["MLIRStandard"]),
  ],
  targets: [
    .systemLibrary(
      name: "CMLIR",
      pkgConfig: "LLVM-for-Swift"),
    .target(
      name: "MLIR",
      dependencies: ["CMLIR"]),
    .testTarget(
      name: "MLIRTests",
      dependencies: ["MLIR"]),
    
    .systemLibrary(
      name: "CMLIRStandard",
      pkgConfig: "LLVM-for-Swift"),
    .target(
      name: "MLIRStandard",
      dependencies: ["CMLIRStandard", "MLIR"]),
    .testTarget(
      name: "MLIRStandardTests",
      dependencies: ["MLIRStandard"]),
  ]
)
