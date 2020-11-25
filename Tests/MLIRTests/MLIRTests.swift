import XCTest
@testable import MLIR

final class MLIRTests: XCTestCase {
    func testModuleParse() throws {
        let module = try Module<Test>(parsing: """
            module {
              func @add(%arg0: memref<?xf32>, %arg1: memref<?xf32>) {
                %c0 = constant 0 : index
                %0 = dim %arg0, %c0 : memref<?xf32>
                %c1 = constant 1 : index
                return
              }
            }
            """)
        print(module)
    }
}
