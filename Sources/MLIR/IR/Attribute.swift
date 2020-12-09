
import CMLIR

public extension MLIRConfiguration {
  typealias Attribute = MLIR.Attribute<Self>
}

public struct Attribute<MLIR: MLIRConfiguration>: MLIRConfigurable, OpaqueStorageRepresentable {
  public static func parse(_ source: String) throws -> Self {
    try parse(borrow, mlirAttributeParseGet, source)
  }
  public static func string(_ value: String) -> Self {
    .borrow(value.withUnsafeMlirStringRef { mlirStringAttrGet(MLIR.ctx, $0.length, $0.data) })!
  }
  let storage: BridgingStorage<MlirAttribute, OwnedByMLIR>
}

extension MlirAttribute: Bridged {
  static let isNull = mlirAttributeIsNull
}
