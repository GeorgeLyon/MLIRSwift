import MLIR

extension Operation.Definition {

  public static func constant(
    _ value: MLIR.Attribute,
    ofType type: MLIR.`Type`
  ) -> Self
  where
    Results == (Value)
  {
    Self(
      .std, "constant",
      attributes: [
        .value(value)
      ],
      resultType: type)
  }

  public static func `return`(_ values: MLIR.Value...) -> Self
  where
    Results == ()
  {
    Self(
      .std, "return",
      operands: values)
  }

}
