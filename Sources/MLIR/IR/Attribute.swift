
import CMLIR

public struct Attribute: CRepresentable, Parsable {
  
  public var context: Context {
    Context(c: mlirAttributeGetContext(c))
  }
  
  let c: MlirAttribute
  
  static let isNull = mlirAttributeIsNull
  static let parse = mlirAttributeParseGet
  
  /// Suppress initializer synthesis
  private init() { fatalError() }
}

public struct NamedAttribute: CRepresentable {
  public init(name: Identifier, attribute: Attribute) {
    c = mlirNamedAttributeGet(name.c, attribute.c)
  }
  let c: MlirNamedAttribute
}
