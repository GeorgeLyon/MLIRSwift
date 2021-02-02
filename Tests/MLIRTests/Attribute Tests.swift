import XCTest
@testable import MLIR

import CMLIR

final class AttributeTests: XCTestCase {
  func testAttributes() throws {
    XCTAssertEqual("\(Attribute.string("Foo"))", #""Foo""#)
    
    let dictionaryAttribute: Attribute = [
      "foo": .string("bar"),
    ]
    XCTAssertEqual("\(dictionaryAttribute)", #"{foo = "bar"}"#)
    
    let arrayAttribute: Attribute = [
      .string("Foo"),
      .string("Bar")
    ]
    XCTAssertEqual("\(arrayAttribute)", #"["Foo", "Bar"]"#)
  }
}
