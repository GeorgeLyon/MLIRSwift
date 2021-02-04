import MLIR

extension Operation where Ownership == OwnedBySwift {
  public static func constant(
    _ value: MLIR.Attribute, ofType type: Type,
    location: Location
  ) -> Operation {
    Operation(
      .std, "constant",
      attributes: ["value": value],
      resultTypes: [type],
      location: location)
  }
  public mutating func dimension(
    of value: MLIR.Value, i: MLIR.Value,
    location: Location
  ) -> Operation {
    Operation(
      .std, "dim",
      operands: [value, i],
      resultTypes: [.index],
      location: location)
  }
  public mutating func `return`(
    _ values: MLIR.Value...,
    location: Location
  ) -> Operation {
    Operation(
      .std, "return",
      operands: values,
      location: location)
  }
}
