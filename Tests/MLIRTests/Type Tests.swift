
import XCTest
@testable import MLIR

final class TypeTests: XCTestCase {
  func testInteger() {
    XCTAssertEqual("\(Type.integer(bitWidth: 1))", "i1")
    XCTAssertEqual("\(Type.integer(.signed, bitWidth: 1))", "si1")
    XCTAssertEqual("\(Type.integer(.unsigned, bitWidth: 1))", "ui1")
  }
}
