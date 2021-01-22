import CMLIR

extension Identifier {
  public static var symbolName: Identifier { "sym_name" }
  public static var type: Identifier { "type" }
}

extension Attribute {
  public static func type(_ type: MLIR.`Type`) -> Self {
    .borrow(mlirTypeAttrGet(.borrow(type)))!
  }
  public static func string(_ value: String) -> Self {
    .borrow(value.withUnsafeMlirStringRef { mlirStringAttrGet(ctx, $0) })!
  }
  public static func flatSymbolReference(_ value: String) -> Self {
    .borrow(value.withUnsafeMlirStringRef { mlirFlatSymbolRefAttrGet(ctx, $0) })!
  }
}
