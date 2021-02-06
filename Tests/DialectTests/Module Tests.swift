import XCTest
import Standard
import SCF

import MLIR

final class ModuleTests: XCTestCase {
  override class func setUp() {
    MLIR.load(.std, .scf)
  }
  override class func tearDown() {
    MLIR.resetContext()
  }
  func testModule() throws {
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
    
    let location = Location(file: #fileID, line: #line, column: #column)
    let constructed = Module(location: location) { ops in
      ops.append(
        .function(
          "swap",
          returning: [.integer(bitWidth: 1), .integer(bitWidth: 1)],
          blocks: [
            Block(.integer(bitWidth: 1), .integer(bitWidth: 1)) { ops, arg0, arg1 in
              ops.append(.return(arg1, arg0), at: location.viaCallsite())
            }
          ]),
        at: location.viaCallsite())
    }
    
    let parsed: Module = try .parse(reference)
    
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