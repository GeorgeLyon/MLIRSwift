// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "MLIR",
  platforms: [
    .macOS(.v11),
  ],
  products: [
    .library(
      name: "CoreMLIR",
      targets: ["CoreMLIR"]),
    .library(
      name: "MLIR",
      targets: ["MLIR"]),
  ],
  dependencies: [
  ],
  targets: [
    .systemLibrary(
      name: "CCoreMLIR",
      pkgConfig: "MLIR"),
    .target(
      name: "CoreMLIR",
      dependencies: ["CCoreMLIR"]),
    .testTarget(
      name: "CoreMLIRTests",
      dependencies: ["CoreMLIR"]),
    
    .systemLibrary(
      name: "CMLIR",
      pkgConfig: "MLIR"),
    .target(
      name: "MLIR",
      dependencies: ["CMLIR", "CoreMLIR"]),
    .testTarget(
      name: "MLIRTests",
      dependencies: ["MLIR"]),
  ]
)
