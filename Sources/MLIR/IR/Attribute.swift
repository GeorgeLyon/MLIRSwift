
import CMLIR

public struct Attribute<MLIR: MLIRConfiguration>: MLIRConfigurable, OpaqueStorageRepresentable {
  public static func parse(_ source: String) throws -> Self {
    try parse(borrow, mlirAttributeParseGet, source)
  }
  public static func string(_ value: String) -> Self {
    .borrow(value.withUnsafeMlirStringRef { mlirStringAttrGet(MLIR.ctx, $0.length, $0.data) })!
  }
  let storage: BridgingStorage<MlirAttribute, OwnedByMLIR>
}

public struct NamedAttributes<MLIR: MLIRConfiguration>: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (String, MLIR.Attribute)...) {
    self.names = elements.map(\.0)
    self.attributes = elements.map(\.1)
  }
  func withUnsafeBorrowedValues<T>(_ body: (UnsafeBufferPointer<MlirNamedAttribute>) throws -> T) rethrows -> T {
    return try names.withUnsafeMlirStringRefs { names in
      precondition(names.count == attributes.count)
      let namedAttributes = zip(names, attributes.map(\.bridgedValue)).map(mlirNamedAttributeGet)
      return try namedAttributes.withUnsafeBufferPointer(body)
    }
  }
  private let names: [String]
  private let attributes: [MLIR.Attribute]
}

// MARK: - Bridging

public extension Attribute {
  init?(_ bridgedValue: MlirAttribute) {
    guard let type = Self.borrow(bridgedValue) else { return nil }
    self = type
  }
  var bridgedValue: MlirAttribute { .borrow(self) }
  
  /**
   Convenience accessor for getting the `MlirContext`
   */
  static var ctx: MlirContext { MLIR.ctx }
}

extension MlirAttribute: Bridged {
  static let isNull = mlirAttributeIsNull
}
