import MLIR

extension Operation {

  public static func constant(
    _ value: MLIR.Attribute,
    ofType type: MLIR.`Type`,
    at location: Location
  ) -> Self
  where
    Results == (Value)
  {
    Self(
      .std, "constant",
      attributes: [
        //        .value(value)
      ],
      resultType: type,
      location: location)
  }

  public static func `return`(_ values: MLIR.Value..., at location: Location) -> Self
  where
    Results == ()
  {
    Self(
      .std, "return",
      operands: values,
      location: location)
  }

}
