
import CMLIR

extension Attribute {
  public static func string(_ string: String) -> Attribute {
    string.withUnsafeMlirStringRef {
      Attribute(c: mlirStringAttrGet(MLIR.context.c, $0.length, $0.data))
    }
  }
}
