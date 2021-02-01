import XCTest
@testable import MLIR

import CMLIR

final class BlockTests: XCTestCase {
  func testLayout() {
    let mlirLayout = MemoryLayout<Block<OwnedByMLIR>>.self
    let swiftLayout = MemoryLayout<Block<OwnedBySwift>>.self
    XCTAssertEqual(mlirLayout.size, swiftLayout.size)
    XCTAssertEqual(mlirLayout.stride, swiftLayout.stride)
  }
}
