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
        XCTAssertEqual(
            "\(module.operation.withPrintingOptions(alwaysPrintInGenericForm: true))",
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
        print(module)
    }
    func testModuleCreate() throws {
        
        let parsed = try! Module<Test>(parsing: """
            module {
                %c0 = constant 0 : index
            }
            """)
        print(parsed.operation)
        let module = Module<Test>(
            operations: [
                Operation.create(
                    name: "func",
                    ownedRegions: [
                        Region.create(
                            blocks: [
                                Block.create(
                                    arguments: TypeList(MemRef.self, MemRef.self),
                                    operations: { arg0, arg1 in
                                        [
                                            Operation.create(
                                                name: "std.constant",
                                                resultTypes: [.index],
                                                operands: [],
                                                attributes: [
                                                    "value": try! Attribute(parsing: "0 : index")
                                                ])
                                        ]
                                    })
                            ])
                    ]),
                Operation.create(name: "module_terminator")
            ])
        print(module.operation)
    }
}
