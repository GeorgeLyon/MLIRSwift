import XCTest

import Dialects
import MLIR

final class ModuleTests: XCTestCase {
  func testCanonicalization() throws {
    let context = MLIR.OwnedContext(dialects: .std)
    let passManager = PassManager(context: context, passes: .canonicalization)
    let module: Module = try context.parse("""
      module  {
        func @swap(%arg0: i1, %arg1: i1) -> (i1, i1) {
          %0 = "std.addi"(%arg0, %arg0) : (i1, i1) -> i1
          return %arg1, %arg0 : i1, i1
        }
      }

      """)
    passManager.runPasses(on: module)
    XCTAssertEqual(
      "\(module.operation)", """
      module  {
        func @swap(%arg0: i1, %arg1: i1) -> (i1, i1) {
          return %arg1, %arg0 : i1, i1
        }
      }

      """)
  }
  
  func testModule() throws {
    let context = MLIR.OwnedContext(dialects: .std)
    let reference = """
      module  {
        func @swap(%arg0: i1, %arg1: i1) -> (i1, i1) {
          return %arg1, %arg0 : i1, i1
        }
      }

      """
    let generic = """
      "module"() ( {
        "func"() ( {
        ^bb0(%arg0: i1, %arg1: i1):  // no predecessors
          "std.return"(%arg1, %arg0) : (i1, i1) -> ()
        }) {sym_name = "swap", type = (i1, i1) -> (i1, i1)} : () -> ()
        "module_terminator"() : () -> ()
      }) : () -> ()

      """
    
    let location: Location = .unknown(in: context)
    
    let constructed = Module(location: location)
    let i1: MLIR.`Type` = .integer(bitWidth: 1, in: context)
    constructed.body.operations.append(
      .function(
        "swap",
        returnTypes: [i1, i1],
        blocks: [
          Block(i1, i1) { ops, a, b in
            ops.append(.return(b, a), at: location.viaCallsite())
          }
        ],
        in: context),
      at: location.viaCallsite())
    XCTAssertTrue(constructed.body.operations.map(\.isValid).reduce(true, { $0 && $1 }))
    XCTAssertTrue(constructed.operation.isValid)
    
    let parsed: Module = try context.parse(reference)
    
    XCTAssertEqual(parsed.body.operations.count, 2) /// Includes the module terminator
    XCTAssertEqual(parsed.operation.regions.count, 1)
    XCTAssertEqual(parsed.operation.regions.first?.blocks.count, 1)
    
    XCTAssertEqual(
      generic,
      "\(constructed.operation.withPrintingOptions(alwaysPrintInGenericForm: true))")
    XCTAssertEqual(
      generic,
      "\(parsed.operation.withPrintingOptions(alwaysPrintInGenericForm: true))")
    
    XCTAssertEqual(reference, "\(constructed.operation)")
    XCTAssertEqual(reference, "\(parsed.operation)")
  }
}
