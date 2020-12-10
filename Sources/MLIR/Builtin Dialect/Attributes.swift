
import CMLIR

public extension AttributeName {
  static let symbolName: AttributeName = "sym_name"
  static let type: AttributeName = "type"
}

public extension Attribute {
  static func type(_ type: MLIR.`Type`) -> Self {
    .borrow(mlirTypeAttrGet(.borrow(type)))!
  }
  static func string(_ value: String) -> Self {
    .borrow(value.withUnsafeMlirStringRef { mlirStringAttrGet(MLIR.ctx, $0) })!
  }
}
