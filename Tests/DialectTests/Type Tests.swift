
import XCTest
@testable import Dialects

import MLIR

final class TypeTests: XCTestCase {
  func testMemRef() throws {
    let context = MLIR.Context(dialects: .std)
    defer { context.destroy() }
    let input = "memref<?xf32>"
    let parsed: Type = try context.parse(input)
    XCTAssertEqual(input, "\(parsed)")
    let constructed: Type = .memoryReference(to: .float32(in: context), withDimensions: [.dynamic])
    XCTAssertEqual(input, "\(constructed)")
  }
}
