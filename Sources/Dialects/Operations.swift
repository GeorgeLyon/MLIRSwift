import MLIR

extension Operation {

  public static func constant(
    _ value: Attribute,
    of type: Type,
    at location: Location
  ) -> Self
  where
    Results == (Value)
  {
    Self(
      .std, "constant",
      attributes: [
        ValueNamedAttribute.value(value)
      ],
      resultType: type,
      location: location)
  }

  public static func `return`(_ values: Value..., at location: Location) -> Self
  where
    Results == ()
  {
    Self(
      .std, "return",
      operands: values,
      location: location)
  }

}
