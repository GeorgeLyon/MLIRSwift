// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "MLIR",
  platforms: [
    .macOS(.v11)
  ],
  products: [
    .library(
      name: "MLIR",
      targets: ["MLIR"]),
    .library(
      name: "MLIRDialects",
      targets: ["Dialects"]),
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
      name: "CDialects",
      pkgConfig: "LLVM-for-Swift"),
    .target(
      name: "Dialects",
      dependencies: ["CDialects", "MLIR"]),
    .testTarget(
      name: "DialectTests",
      dependencies: ["Dialects"]),
  ]
)
