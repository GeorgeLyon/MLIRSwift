import XCTest
@testable import MLIR

final class MLIRTests: XCTestCase {
    func testModuleParse() throws {
        let module = try Module<Standard>(parsing: """
            module {
            }
            """)
        print(module.operation)
    }
}
