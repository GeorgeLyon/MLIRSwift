import XCTest
@testable import MLIR

import CMLIR

final class AttributeTests: XCTestCase {
  func testAttributes() throws {
    let context = MLIR.OwnedContext()
    XCTAssertEqual("\(Attribute.string("Foo", in: context))", #""Foo""#)
    
    let dictionaryAttribute: Attribute = .dictionary([
      NamedAttribute(name: "foo", attribute: .string("bar", in: context))
    ], in: context)
    XCTAssertEqual("\(dictionaryAttribute)", #"{foo = "bar"}"#)
    
    let arrayAttribute: Attribute = .array([
      .string("Foo", in: context),
      .string("Bar", in: context)
    ], in: context)
    XCTAssertEqual("\(arrayAttribute)", #"["Foo", "Bar"]"#)
  }
}
