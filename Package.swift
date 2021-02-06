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
      targets: ["Standard"]),
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
      name: "CStandard",
      pkgConfig: "LLVM-for-Swift"),
    .target(
      name: "Standard",
      dependencies: ["CStandard", "MLIR"]),
    
    .systemLibrary(
      name: "CSCF",
      pkgConfig: "LLVM-for-Swift"),
    .target(
      name: "SCF",
      dependencies: ["CSCF", "MLIR"]),
    
    .testTarget(
      name: "DialectTests",
      dependencies: ["SCF", "Standard"]),
  ]
)
