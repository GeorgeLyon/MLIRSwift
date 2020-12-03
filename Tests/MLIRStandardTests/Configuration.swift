
import MLIR
import MLIRStandard

enum Test:
  MLIRConfiguration,
  ProvidesStandardDialect
{
  static let context = Context(dialects: [standard])
}

enum MemRef_xf32<MLIR: MLIRConfiguration>: TypeClass {
  static var type: Type<MLIR> { try! Type(parsing: "memref<?xf32>") }
}
