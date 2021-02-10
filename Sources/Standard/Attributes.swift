import CStandard
import MLIR

extension Attribute {
  public static func integer(_ value: Int, of type: MLIR.`Type`) -> Attribute {
    Attribute(mlirIntegerAttrGet(type.cRepresentation, Int64(value)))!
  }
}

extension NamedAttribute {
  public static func value(_ attribute: Attribute) -> NamedAttribute {
    NamedAttribute(
      name: Identifier("value", in: attribute.context),
      attribute: attribute)
  }
}
