
public struct BuildableOperation<ResultTypes> {
  let dialect: Dialect?
  let name: String
  let attributes: MLIR.NamedAttributes
  let operands: [MLIR.Value]
  let resultTypes: [MLIR.`Type`]
  let regions: [MLIR.Region<OwnedBySwift>]
  
  func makeOperation(at location: Location) -> Operation<OwnedBySwift> {
    let operation: Operation<OwnedBySwift>
    if let dialect = dialect {
      operation = Operation(
        dialect, name,
        attributes: attributes,
        operands: operands,
        resultTypes: resultTypes,
        regions: regions,
        location: location)
    } else {
      operation = Operation(
        name,
        attributes: attributes,
        operands: operands,
        resultTypes: resultTypes,
        regions: regions,
        location: location)
    }
    return operation
  }
}
