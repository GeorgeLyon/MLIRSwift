
import CMLIR

public struct Attribute<MLIR: MLIRConfiguration>: MLIRConfigurable, OpaqueStorageRepresentable {
  public static func parse(_ source: String) throws -> Self {
    try parse(borrow, mlirAttributeParseGet, source)
  }
  let storage: BridgingStorage<MlirAttribute, OwnedByMLIR>
}

public struct NamedAttributes<MLIR: MLIRConfiguration>: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (AttributeName, MLIR.Attribute)...) {
    self.names = elements.map(\.0.value)
    self.attributes = elements.map(\.1)
  }
  public static func +(lhs: Self, rhs: Self) -> Self {
    var result = lhs
    result.names.append(contentsOf: rhs.names)
    result.attributes.append(contentsOf: rhs.attributes)
    return result
  }
  func withUnsafeBorrowedValues<T>(_ body: (UnsafeBufferPointer<MlirNamedAttribute>) throws -> T) rethrows -> T {
    return try names.withUnsafeMlirStringRefs { names in
      precondition(names.count == attributes.count)
      let namedAttributes = zip(names, attributes.map(\.bridgedValue)).map(mlirNamedAttributeGet)
      return try namedAttributes.withUnsafeBufferPointer(body)
    }
  }
  private var names: [String]
  private var attributes: [MLIR.Attribute]
}

public struct AttributeName: CustomStringConvertible, ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.value = value
  }
  public var description: String { value }
  fileprivate let value: String
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
