
import XCTest
@testable import MLIR

final class TypeTests: XCTestCase {
  func testInteger() {
    XCTAssertEqual("\(Type<Test>.integer(bitWidth: 1))", "i1")
    XCTAssertEqual("\(Type<Test>.integer(.signed, bitWidth: 1))", "si1")
    XCTAssertEqual("\(Type<Test>.integer(.unsigned, bitWidth: 1))", "ui1")
  }
}
