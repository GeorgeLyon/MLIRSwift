
import XCTest
@testable import MLIR

final class TypeTests: XCTestCase {
  func testInteger() {
    let context = MLIR.OwnedContext()
    XCTAssertEqual("\(context.get(.integer(bitWidth: 1)))", "i1")
    XCTAssertEqual("\(context.get(.integer(.signed, bitWidth: 1)))", "si1")
    XCTAssertEqual("\(context.get(.integer(.unsigned, bitWidth: 1)))", "ui1")
  }
}
