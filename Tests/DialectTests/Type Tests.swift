
import XCTest
@testable import Standard

import MLIR

final class TypeTests: XCTestCase {
  func testMemRef() throws {
    let context = MLIR.OwnedContext(dialects: .std)
    let input = "memref<?xf32>"
    let parsed: Type = try context.parse(input)
    XCTAssertEqual(input, "\(parsed)")
    let constructed = Type.memref(shape: [.dynamic], element: .float32(in: context))
    XCTAssertEqual(input, "\(constructed)")
  }
}
