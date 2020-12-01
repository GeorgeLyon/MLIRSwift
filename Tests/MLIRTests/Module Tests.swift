import XCTest
@testable import MLIR

final class ModuleTests: XCTestCase {
  func testAdd() throws {
    let input = """
      module  {
        func @add(%arg0: memref<?xf32>, %arg1: memref<?xf32>) {
          %c0 = constant 0 : index
          %0 = dim %arg0, %c0 : memref<?xf32>
          %c1 = constant 1 : index
          scf.for %arg2 = %c0 to %0 step %c1 {
            %1 = load %arg0[%arg2] : memref<?xf32>
            %2 = load %arg1[%arg2] : memref<?xf32>
            %3 = addf %1, %2 : f32
            store %3, %arg0[%arg2] : memref<?xf32>
          }
          return
        }
      }
      """
    let parsed = try Test.Module(parsing: input)
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
          "scf.for"(%c0, %0, %c1) ( {
          ^bb0(%arg2: index):  // no predecessors
            %1 = "std.load"(%arg0, %arg2) : (memref<?xf32>, index) -> f32
            %2 = "std.load"(%arg1, %arg2) : (memref<?xf32>, index) -> f32
            %3 = "std.addf"(%1, %2) : (f32, f32) -> f32
            "std.store"(%3, %arg0, %arg2) : (f32, memref<?xf32>, index) -> ()
            "scf.yield"() : () -> ()
          }) : (index, index, index) -> ()
          "std.return"() : () -> ()
        }) {sym_name = "add", type = (memref<?xf32>, memref<?xf32>) -> ()} : () -> ()
        "module_terminator"() : () -> ()
      }) : () -> ()
      """)
    let constructed = try Test.Module(
      operations: { operations in
        try operations.build(
          "func",
          attributes: [
            "sym_name": try Attribute(parsing: "\"add\""),
            "type": try Attribute(parsing: "(memref<?xf32>, memref<?xf32>) -> ()")
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
                        "value": try Attribute(parsing: "0 : index")
                      ])
                    let dim = operations.build(
                      "std.dim",
                      results: TypeList(Index.self),
                      operands: [arg0, c0],
                      regions: { _ in })
                    let c1 = operations.build(
                      "std.constant",
                      results: TypeList(Index.self),
                      attributes: [
                        "value": try Attribute(parsing: "1 : index")
                      ])
                    operations.build(
                      "scf.for",
                      operands: [c0, dim, c1],
                      regions: { builder in
                        builder.build(
                          blocks: { builder in
                            builder.build(
                              arguments: TypeList(Index.self),
                              operations: { builder, index in
                                let v1 = builder.build("std.load", results: TypeList(F32.self), operands: [arg0, index])
                                let v2 = builder.build("std.load", results: TypeList(F32.self), operands: [arg1, index])
                                let v3 = builder.build("std.addf", results: TypeList(F32.self), operands: [v1, v2])
                                builder.build("std.store", operands: [v3, arg0, index])
                                builder.build("scf.yield")
                              })
                          })
                      })
                    operations.build("std.return")
                  })
              })
          })
      })
    XCTAssertEqual(input, "\(constructed.operation)")
  }
}
