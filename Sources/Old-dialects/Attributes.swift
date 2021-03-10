import CDialects
import MLIR

extension Attribute {

}

extension NamedAttribute {
  public static func value(_ attribute: Attribute) -> NamedAttribute {
    NamedAttribute(
      name: Identifier("value", in: attribute.context),
      attribute: attribute)
  }
}
