
import XCTest
@testable import MLIR

import CMLIR

final class TypeTests: XCTestCase {
  func testMemRef() throws {
    let input = "memref<?xf32>"
    let parsed = try Type<Test>(parsing: input)
    XCTAssertEqual(input, "\(parsed)")
    let constructed = Type<Test>.memRef(shape: [.dynamic], element: .f32)
    XCTAssertEqual(input, "\(constructed)")
  }
}
