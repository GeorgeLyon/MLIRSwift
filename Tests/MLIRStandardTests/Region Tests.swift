
import XCTest
@testable import MLIRStandard

import MLIR

final class RegionTests: XCTestCase {
  override class func setUp() {
    MLIR.load(.std)
  }
  override class func tearDown() {
    MLIR.resetContext()
  }
  func testMemRef() throws {
    let input = "memref<?xf32>"
    let parsed = try Type.parse(input)
    XCTAssertEqual(input, "\(parsed)")
    let constructed = Type.memref(shape: [.dynamic], element: .f32)
    XCTAssertEqual(input, "\(constructed)")
  }
}
