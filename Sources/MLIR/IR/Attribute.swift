
import CMLIR

public struct Attribute: CRepresentable, Parsable, Printable {
  public init?(_ cRepresentation: MlirAttribute) {
    self.init(c: cRepresentation)
  }
  public var cRepresentation: MlirAttribute { c }
  public var context: UnownedContext {
    UnownedContext(c: mlirAttributeGetContext(c))!
  }
  
  let c: MlirAttribute
  
  static let isNull = mlirAttributeIsNull
  static let parse = mlirAttributeParseGet
  static let print = mlirAttributePrint
}

public struct NamedAttribute: CRepresentable {
  public init(name: Identifier, attribute: Attribute) {
    c = mlirNamedAttributeGet(name.c, attribute.c)
  }
  public init(name: String, attribute: Attribute) {
    self.init(name: Identifier(name, in: attribute.context), attribute: attribute)
  }
  let c: MlirNamedAttribute
}
