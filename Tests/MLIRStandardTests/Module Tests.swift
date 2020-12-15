import XCTest
@testable import MLIRStandard

import MLIR

final class ModuleTests: XCTestCase {
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
    let parsed: Test.Module = try  .parse(input)
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
    let memref = Type<Test>.memref(shape: [.dynamic], element: .f32)
    let constructed = try Test.Module {
      Func(
        "add",
        entryBlock: try Block(memref, memref) { op, arg0, arg1 in
          let c0 = op.build(Constant(value: try .parse("0 : index"), type: .index))
          let _ = op.build(Dim(of: arg0, c0))
          let _ = op.build(Constant(value: try .parse("1 : index"), type: .index))
          op.build(Return())
        })
    }
    XCTAssertEqual(input, "\(constructed.operation)")
  }
}
