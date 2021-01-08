
import CMLIR

public struct Attribute<MLIR: MLIRConfiguration>: MLIRConfigurable, OpaqueStorageRepresentable {
  public static func parse(_ source: String) throws -> Self {
    try parse(borrow, mlirAttributeParseGet, source)
  }
  let storage: BridgingStorage<MlirAttribute, OwnedByMLIR>
}

public struct NamedAttributes<MLIR: MLIRConfiguration>: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (MLIR.Identifier, MLIR.Attribute)...) {
    self.elements = elements.map {
      mlirNamedAttributeGet(.borrow($0.0), .borrow($0.1))
    }
  }
  public static func +(lhs: Self, rhs: Self) -> Self {
    var result = lhs
    result.elements.append(contentsOf: rhs.elements)
    return result
  }
  func withUnsafeBorrowedValues<T>(_ body: (UnsafeBufferPointer<MlirNamedAttribute>) throws -> T) rethrows -> T {
    try elements.withUnsafeBufferPointer(body)
  }
  private var elements: [MlirNamedAttribute]
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
