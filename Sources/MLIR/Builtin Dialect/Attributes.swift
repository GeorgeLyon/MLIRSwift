
import CMLIR

public extension Identifier {
  static var symbolName: Identifier { "sym_name" }
  static var type: Identifier { "type" }
}

public extension Attribute {
  static func type(_ type: MLIR.`Type`) -> Self {
    .borrow(mlirTypeAttrGet(.borrow(type)))!
  }
  static func string(_ value: String) -> Self {
    .borrow(value.withUnsafeMlirStringRef { mlirStringAttrGet(ctx, $0) })!
  }
  static func flatSymbolReference(_ value: String) -> Self {
    .borrow(value.withUnsafeMlirStringRef { mlirFlatSymbolRefAttrGet(ctx, $0) })!
  }
}
