import CMLIR

extension Identifier {
  public static var symbolName: Identifier { "sym_name" }
  public static var type: Identifier { "type" }
}

extension Attribute: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: MLIR.Attribute...) {
    self = elements.withUnsafeBorrowedValues { buffer in
      .borrow(mlirArrayAttrGet(MLIR.context, buffer.count, buffer.baseAddress))!
    }
  }
}

extension Attribute: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (MLIR.Identifier, MLIR.Attribute)...) {
    self =
      elements
      .map {
        mlirNamedAttributeGet(.borrow($0.0), .borrow($0.1))
      }
      .withUnsafeBufferPointer { buffer in
        .borrow(mlirDictionaryAttrGet(MLIR.context, buffer.count, buffer.baseAddress))!
      }
  }
}

extension Attribute {
  public static func type(_ type: MLIR.`Type`) -> Self {
    .borrow(mlirTypeAttrGet(.borrow(type)))!
  }
  public static func string(_ value: String) -> Self {
    .borrow(value.withUnsafeMlirStringRef { mlirStringAttrGet(MLIR.context, $0) })!
  }
  public static func flatSymbolReference(_ value: String) -> Self {
    .borrow(value.withUnsafeMlirStringRef { mlirFlatSymbolRefAttrGet(MLIR.context, $0) })!
  }
}
