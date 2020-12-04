
import CMLIR

/**
 While these are declared in `StandardAttributes.h`, they are not technically part of the standard dialect as evidenced us being able to create these attributes in `MLIRTests` which do not register the standard dialect.
 */
extension Attribute where MLIR: MLIRConfiguration {
  public static func string(_ string: String) -> Attribute {
    string.withUnsafeMlirStringRef {
      Attribute(c: mlirStringAttrGet(MLIR.context.c, $0.length, $0.data))
    }
  }
  public static func flatSymbolReference(_ symbol: String) -> Attribute {
    symbol.withUnsafeMlirStringRef {
      Attribute(c: mlirFlatSymbolRefAttrGet(MLIR.context.c, $0.length, $0.data))
    }
  }
  public static func opaque(
    _ dialect: MLIR.RegisteredDialect,
    _ data: UnsafeRawBufferPointer,
    ofType type: MLIR.`Type`) -> Attribute
  {
    let cData = data.bindMemory(to: Int8.self)
    return Attribute(c: mlirOpaqueAttrGet(MLIR.context.c, dialect.namespace, cData.count, cData.baseAddress, type.c))
  }
}
