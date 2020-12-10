
import XCTest
@testable import MLIRStandard

import MLIR

final class TypeTests: XCTestCase {
  func testMemRef() throws {
    let input = "memref<?xf32>"
    let parsed = try Type<Test>.parse(input)
    XCTAssertEqual(input, "\(parsed)")
    let constructed = Type<Test>.memref(shape: [.dynamic], element: .f32)
    XCTAssertEqual(input, "\(constructed)")
  }
}
