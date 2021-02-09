
import CMLIR

public struct Attribute: CRepresentable {
  let c: MlirAttribute
  
  static let isNull = mlirAttributeIsNull
}

public struct NamedAttributes: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (MLIR.Identifier, MLIR.Attribute)...) {
    self.elements = elements.map {
      mlirNamedAttributeGet($0.0.c, $0.1.c)
    }
  }
  public mutating func append(_ identifier: MLIR.Identifier, _ attribute: MLIR.Attribute) {
    elements.append(mlirNamedAttributeGet(identifier.c, attribute.c))
  }
  public static func + (lhs: Self, rhs: Self) -> Self {
    var result = lhs
    result.elements.append(contentsOf: rhs.elements)
    return result
  }
  func withUnsafeCRepresentation<T>(_ body: (UnsafeBufferPointer<MlirNamedAttribute>) throws -> T)
    rethrows -> T
  {
    try elements.withUnsafeBufferPointer(body)
  }
  private var elements: [MlirNamedAttribute]
}
