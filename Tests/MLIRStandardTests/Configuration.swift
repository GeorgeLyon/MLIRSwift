
import MLIR
import MLIRStandard

enum Test: MLIRConfiguration
{
  struct DialectRegistry:
    MLIR.DialectRegistry,
    ProvidesStandardDialect
  {
    static var dialects: [RegisteredDialect] = [
      \.standard
    ]
  }
  static let context = Context()
}

enum MemRef_xf32<MLIR: MLIRConfiguration>: TypeClass {
  static var type: Type<MLIR> { try! Type(parsing: "memref<?xf32>") }
}
