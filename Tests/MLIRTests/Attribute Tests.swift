import XCTest
@testable import MLIR

final class AttributeTests: XCTestCase {
    func testParse() throws {
        let attribute = try Test.Attribute(parsing: "0 : index")
        XCTAssertEqual("\(attribute)", "0 : index")
    }
}
