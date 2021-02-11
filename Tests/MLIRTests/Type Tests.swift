
import XCTest
@testable import MLIR

final class TypeTests: XCTestCase {
  func testInteger() {
    let context = MLIR.OwnedContext()
    XCTAssertEqual("\(Type.integer(bitWidth: 1, in: context))", "i1")
    XCTAssertEqual("\(Type.integer(.signed, bitWidth: 1, in: context))", "si1")
    XCTAssertEqual("\(Type.integer(.unsigned, bitWidth: 1, in: context))", "ui1")
  }
}
