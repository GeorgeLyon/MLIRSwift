import MLIR

extension BuildableOperation{
  
  public static func constant(
    _ value: MLIR.Attribute,
    ofType type: MLIR.`Type`) -> Self
  where
    ResultTypes == (MLIR.`Type`)
  {
    Self(
      .std, "constant",
      attributes: [
        "value": value
      ],
      resultType: type)
  }
  
  public static func `return`(_ values: MLIR.Value...) -> Self
  where
    ResultTypes == ()
  {
    Self(
      .std, "return",
      operands: values)
  }
  
}
