import XCTest
@testable import MLIR

import CMLIR

final class AttributeTests: XCTestCase {
  func testAttributes() throws {
    let context = MLIR.OwnedContext()
    
    func test(
      _ source: String,
      parsesAs attribute: ContextualAttribute,
      file: StaticString = #filePath, line: UInt = #line
    ) {
      do {
        let parsed = try context.parse(source, as: Attribute.self)
        XCTAssertEqual(parsed, attribute.in(context), file: file, line: line)
      } catch {
        XCTFail(file: file, line: line)
      }
    }

    test(#""foo""#, parsesAs: StringAttribute.string("foo"))
    
    test(#"["foo", "bar"]"#, parsesAs: ArrayAttribute.array([.string("foo"), StringAttribute.string("bar")]))
    /// Uncommenting the following line traps
//    test(#"["foo", "bar"]"#, parsesAs: .array([.string("foo"), .string("bar")]))
    
    test(#"{foo = "bar"}"#, parsesAs: DictionaryAttribute.dictionary(["foo": StringAttribute.string("bar")]))
    /// Uncommenting the following line traps
//     test(#"{foo = "bar"}"#, parsesAs: .dictionary(["foo": StringAttribute.string("bar")]))
  }
}
