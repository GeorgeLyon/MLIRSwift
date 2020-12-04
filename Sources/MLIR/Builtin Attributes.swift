
import CMLIR

extension Attribute {
  public static func string(_ string: String) -> Attribute {
    string.withUnsafeMlirStringRef {
      Attribute(c: mlirStringAttrGet(MLIR.context.c, $0.length, $0.data))
    }
  }
  public static func opaque(
    _ dialect: MLIR.RegisteredDialect,
    _ data: UnsafeRawBufferPointer,
    ofType type: MLIR.`Type`) -> Attribute
  {
    let cData = data.bindMemory(to: Int8.self)
    return Attribute(c: mlirOpaqueAttrGet(MLIR.context.c, MLIR.namespace(of: dialect), cData.count, cData.baseAddress, type.c))
  }
}
