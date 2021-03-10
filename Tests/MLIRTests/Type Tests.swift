
import XCTest
@testable import MLIR

final class TypeTests: XCTestCase {
  func testInteger() {
    let context = MLIR.OwnedContext()
    
    func test(
      _ source: String,
      parsesAs type: ContextualType,
      file: StaticString = #filePath, line: UInt = #line
    ) {
      do {
        let parsed = try context.parse(source, as: Type.self)
        XCTAssertEqual(parsed, type.in(context), file: file, line: line)
      } catch {
        XCTFail(file: file, line: line)
      }
    }
    
    test("i1", parsesAs: .integer(bitWidth: 1))
    test("si1", parsesAs: .integer(.signed, bitWidth: 1))
    test("ui1", parsesAs: .integer(.unsigned, bitWidth: 1))
  }
}
