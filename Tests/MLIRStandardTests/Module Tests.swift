import XCTest
@testable import MLIRStandard

import MLIR

final class ModuleTests: XCTestCase {
  override class func setUp() {
    MLIR.register(.std)
  }
  func testModule() throws {
    let input = """
      module  {
        func @add(%arg0: memref<?xf32>, %arg1: memref<?xf32>) {
          %c0 = constant 0 : index
          %0 = dim %arg0, %c0 : memref<?xf32>
          %c1 = constant 1 : index
          return
        }
      }

      """
    let parsed: Module = try .parse(input)
    XCTAssertEqual(parsed.body.operations.count, 2)
    XCTAssertEqual(parsed.operation.regions.count, 1)
    XCTAssertEqual(parsed.operation.regions.first?.blocks.count, 1)
    XCTAssertEqual(input, "\(parsed.operation)")
    XCTAssertEqual(
      "\(parsed.operation.withPrintingOptions(alwaysPrintInGenericForm: true))",
      """
      "module"() ( {
        "func"() ( {
        ^bb0(%arg0: memref<?xf32>, %arg1: memref<?xf32>):  // no predecessors
          %c0 = "std.constant"() {value = 0 : index} : () -> index
          %0 = "std.dim"(%arg0, %c0) : (memref<?xf32>, index) -> index
          %c1 = "std.constant"() {value = 1 : index} : () -> index
          "std.return"() : () -> ()
        }) {sym_name = "add", type = (memref<?xf32>, memref<?xf32>) -> ()} : () -> ()
        "module_terminator"() : () -> ()
      }) : () -> ()

      """)
    let memref = Type.memref(shape: [.dynamic], element: .f32)
    let constructed = try Module { op in
      try op.buildFunc("add") {
        try Block(memref, memref) { op, arg0, arg1 in
          let c0 = op.buildConstant(try .parse("0 : index"), ofType: .index)
          _ = op.buildDim(of: arg0, i: c0)
          _ = op.buildConstant(try .parse("1 : index"), ofType: .index)
          op.buildReturn()
        }
      }
    }
    XCTAssertEqual(input, "\(constructed.operation)")
  }
}
