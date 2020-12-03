
import MLIR
import MLIRDialects

enum Test:
  MLIRConfiguration,
  ProvidesStandardDialect
{
  static let context = Context(registerAllDialects: true)
}

enum MemRef_xf32<MLIR: MLIRConfiguration>: TypeClass {
  static var type: Type<MLIR> { try! Type(parsing: "memref<?xf32>") }
}
