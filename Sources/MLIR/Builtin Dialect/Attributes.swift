import CMLIR

extension Attribute {
  public static func string(_ string: String, in context: Context) -> Self {
    Attribute(c: string.withUnsafeMlirStringRef { mlirStringAttrGet(context.cRepresentation, $0) })!
  }
  public static func type(_ type: MLIR.`Type`) -> Self {
    Attribute(c: mlirTypeAttrGet(type.c))!
  }
  public static func array(_ attributes: [Attribute], in context: Context) -> Attribute {
    attributes.withUnsafeCRepresentation {
      Attribute(c: mlirArrayAttrGet(context.cRepresentation, $0.count, $0.baseAddress))!
    }
  }
  public static func dictionary(_ attributes: [NamedAttribute], in context: Context) -> Attribute {
    attributes.withUnsafeCRepresentation {
      Attribute(c: mlirDictionaryAttrGet(context.cRepresentation, $0.count, $0.baseAddress))!
    }
  }
  public static func flatSymbolReference(_ name: String, in context: Context) -> Attribute {
    name.withUnsafeMlirStringRef {
      Attribute(c: mlirFlatSymbolRefAttrGet(context.cRepresentation, $0))!
    }
  }
}

extension NamedAttribute {
  public static func symbolName(_ name: String, in context: Context) -> NamedAttribute {
    NamedAttribute(
      name: Identifier("sym_name", in: context),
      attribute: .string(name, in: context))
  }
  public static func type(_ type: MLIR.`Type`) -> NamedAttribute {
    NamedAttribute(name: Identifier("type", in: type.context), attribute: .type(type))
  }
}
