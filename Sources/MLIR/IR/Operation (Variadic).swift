
public extension OperationProtocol where ResultTypes == MLIR.`Type` {
  static func types(of resultTypes: ResultTypes) -> [MLIR.`Type`] {
    let (t0) = resultTypes
    return [t0]
  }
  static func results(from operationResults: MLIR.Operation<OwnedBySwift>.Results) -> MLIR.Value {
    (operationResults[0])
  }
}
