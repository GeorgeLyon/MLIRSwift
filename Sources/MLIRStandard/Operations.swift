import MLIR

extension OperationBuilder where MLIR: ProvidesStandardDialect {
  public mutating func buildConstant(
    _ value: MLIR.Attribute, ofType type: Type<MLIR>,
    file: StaticString = #file, line: Int = #line, column: Int = #column
  ) -> MLIR.Value {
    let results = buildGenericOperation(file: file, line: line, column: column) { op in
      op.build(.std, "constant", attributes: ["value": value], resultTypes: [type])
    }
    return results[0]
  }
  public mutating func buildDim(
    of value: MLIR.Value, i: MLIR.Value,
    file: StaticString = #file, line: Int = #line, column: Int = #column
  ) -> MLIR.Value {
    let results = buildGenericOperation(file: file, line: line, column: column) { op in
      op.build(.std, "dim", operands: [value, i], resultTypes: [.index])
    }
    return results[0]
  }
  public mutating func buildReturn(
    _ values: MLIR.Value...,
    file: StaticString = #file, line: Int = #line, column: Int = #column
  ) {
    buildGenericOperation(file: file, line: line, column: column) { op in
      op.build(.std, "return", operands: values)
    }
  }
}
