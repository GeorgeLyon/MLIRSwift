
import MLIR

enum Test:
  MLIRConfiguration,
  ProvidesStandardDialect
{
  static let context = Context(registerAllDialects: true)
}

extension Type where MLIR: MLIRConfiguration {
  static var memref_xf32: Type { try! Type(parsing: "memref<?xf32>") }
  static var index: Type { try! Type(parsing: "index") }
  static var f32: Type { try! Type(parsing: "f32") }
}

enum MemRef_xf32<MLIR: MLIRConfiguration>: TypeClass {
  static var type: Type<MLIR> { .memref_xf32 }
}

enum Index<MLIR: MLIRConfiguration>: TypeClass {
  static var type: Type<MLIR> { .index }
}

enum F32<MLIR: MLIRConfiguration>: TypeClass {
  static var type: Type<MLIR> { .f32 }
}

