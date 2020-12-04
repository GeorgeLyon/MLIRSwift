
import MLIR
import MLIRStandard

enum Test:
  MLIRConfiguration,
  ProvidesStandardDialect
{
  static let dialects: [RegisteredDialect] = [
    .standard
  ]
  static let context = Context()
}

enum MemRef_xf32<MLIR: MLIRConfiguration>: TypeClass {
  static var type: Type<MLIR> { try! .parsing("memref<?xf32>") }
}
