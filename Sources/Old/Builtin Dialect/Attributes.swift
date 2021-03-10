import CMLIR

extension Attribute {
  public static func string(_ string: String, in context: Context) -> Self {
    Attribute(c: string.withUnsafeMlirStringRef { mlirStringAttrGet(context.cRepresentation, $0) })!
  }
  public static func integer(_ value: Int, of type: MLIR.`Type`) -> Attribute {
    Attribute(mlirIntegerAttrGet(type.cRepresentation, Int64(value)))!
  }
  public static func type(_ type: MLIR.`Type`) -> Self {
    Attribute(c: mlirTypeAttrGet(type.c))!
  }
  public static func type(_ type: ContextualType, in context: Context) -> Self {
    Attribute(c: mlirTypeAttrGet(context.get(type).c))!
  }
  public static func array(_ attributes: [Attribute], in context: Context) -> Attribute {
    attributes.withUnsafeCRepresentation {
      Attribute(c: mlirArrayAttrGet(context.cRepresentation, $0.count, $0.baseAddress))!
    }
  }
  public static func array(_ head: Attribute, _ tail: Attribute...) -> Attribute {
    array([head] + tail, in: head.context)
  }
  public static func dictionary(_ attributes: [NamedAttribute], in context: Context) -> Attribute {
    attributes.withUnsafeCRepresentation {
      Attribute(c: mlirDictionaryAttrGet(context.cRepresentation, $0.count, $0.baseAddress))!
    }
  }
  public static func dictionary(_ head: NamedAttribute, _ tail: NamedAttribute...) -> Attribute {
    dictionary([head] + tail, in: head.attribute.context)
  }
  public static func flatSymbolReference(_ name: String, in context: Context) -> Attribute {
    name.withUnsafeMlirStringRef {
      Attribute(c: mlirFlatSymbolRefAttrGet(context.cRepresentation, $0))!
    }
  }
}

extension NamedAttribute {
  /// Specify attributes associated with the `i`th argument to an operation
  public static func argument(
    _ i: Int,
    attributes head: NamedAttribute,
    _ tail: NamedAttribute...
  ) -> NamedAttribute {
    let context = head.attribute.context
    return NamedAttribute(
      name: "arg\(i)",
      attribute: .dictionary([head] + tail, in: context))
  }
  /// Specify attributes associated with the `i`th result to an operation
  public static func result(
    _ i: Int,
    attributes head: NamedAttribute,
    _ tail: NamedAttribute...
  ) -> NamedAttribute {
    let context = head.attribute.context
    return NamedAttribute(
      name: "result\(i)",
      attribute: .dictionary([head] + tail, in: context))
  }
  public static func symbolName(_ name: String, in context: Context) -> NamedAttribute {
    NamedAttribute(name: "sym_name", attribute: .string(name, in: context))
  }
  public static func type(_ type: MLIR.`Type`) -> NamedAttribute {
    NamedAttribute(name: "type", attribute: .type(type))
  }
  public static func type(_ type: ContextualType, in context: Context) -> NamedAttribute {
    NamedAttribute(name: "type", attribute: .type(type, in: context))
  }
}

extension Array where Element == NamedAttribute {
  public static func function<Inputs, Results>(
    _ name: String,
    of inputs: Inputs,
    to results: Results,
    in context: Context
  ) -> Self
  where
    Inputs: Sequence,
    Inputs.Element == Type,
    Results: Sequence,
    Results.Element == Type
  {
    [
      .symbolName(name, in: context),
      .type(.function(of: inputs, to: results), in: context),
    ]
  }
}
