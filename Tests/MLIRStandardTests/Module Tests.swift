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
    XCTAssertEqual(Array(parsed.body.operations).count, 2)
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
    /*
    let constructed = try Test.Module(
      operations: { operations in
        try operations.build(
          "func",
          attributes: [
            "sym_name": .string("add"),
            "type": try .parsing("(memref<?xf32>, memref<?xf32>) -> ()")
          ],
          regions: { regions in
            try regions.build(
              blocks: { builder in
                try builder.build(
                  arguments: TypeList(MemRef_xf32.self, MemRef_xf32.self),
                  operations: { (operations, arg0, arg1) in
                    let c0 = operations.build(
                      "std.constant",
                      results: TypeList(Index.self),
                      attributes: [
                        "value": try .parsing("0 : index")
                      ])
                    let _ = operations.build(
                      "std.dim",
                      results: TypeList(Index.self),
                      operands: [arg0, c0],
                      regions: { _ in })
                    let _ = operations.build(
                      "std.constant",
                      results: TypeList(Index.self),
                      attributes: [
                        "value": try .parsing("1 : index")
                      ])
                    operations.build("std.return")
                  })
              })
          })
      })
    XCTAssertEqual(input, "\(constructed.operation)")
    */
  }
}
