import XCTest
@testable import MLIR

import CMLIR

final class BlockTests: XCTestCase {
  func testLayout() {
    XCTAssertEqual(MemoryLayout<Test.Block<OwnedByMLIR>>.size, MemoryLayout<MlirBlock>.size)
    XCTAssertEqual(MemoryLayout<Test.Block<OwnedByMLIR>>.stride, MemoryLayout<MlirBlock>.stride)
  }
}
