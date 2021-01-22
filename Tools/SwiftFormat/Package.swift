// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftFormat",
    dependencies: [
      .package(url: "https://github.com/apple/swift-format", .branch("swift-5.3-branch"))
    ],
    targets: []
)
