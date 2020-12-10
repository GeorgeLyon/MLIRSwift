import XCTest
@testable import MLIR

import CMLIR

final class AttributeTests: XCTestCase {
  func testAttributes() throws {
    XCTAssertEqual("\(Test.Attribute.string("Foo"))", "\"Foo\"")
  }
}
