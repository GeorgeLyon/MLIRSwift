import XCTest
@testable import MLIR

import CMLIR

final class AttributeTests: XCTestCase {
  func testAttributes() throws {
    XCTAssertEqual("\(Attribute.string("Foo"))", "\"Foo\"")
  }
}
