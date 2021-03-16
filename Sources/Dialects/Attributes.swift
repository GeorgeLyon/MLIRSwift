import CDialects
import MLIR

extension Attribute {

}

public struct ValueNamedAttribute: ContextualNamedAttributeProtocol {
  public let attribute: ContextualAttribute
  public func `in`(_ context: Context) -> NamedAttribute {
    NamedAttribute(name: "value", attribute: attribute.in(context))
  }
}
extension ContextualNamedAttributeProtocol where Self == ValueNamedAttribute {
  public static func value(_ attribute: Attribute) -> Self {
    ValueNamedAttribute(attribute: attribute)
  }
}
