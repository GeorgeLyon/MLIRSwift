
extension Block.Operations {
  public func append(_ op: BuildableOperation<()>, at location: Location) -> ()
  {
    let operation = append(op.makeOperation(at: location))
    let results = operation.results
    assert(results.count == 0)
    return ()
  }
  public func append(_ op: BuildableOperation<(MLIR.`Type`)>, at location: Location) -> (MLIR.Value)
  {
    let operation = append(op.makeOperation(at: location))
    let results = operation.results
    assert(results.count == 1)
    return (results[0])
  }
}

public struct BuildableOperation<ResultTypes> {
  let dialect: Dialect?
  let name: String
  let attributes: MLIR.NamedAttributes
  let operands: [MLIR.Value]
  let resultTypes: [MLIR.`Type`]
  let regions: [MLIR.Region<OwnedBySwift>]
  
  func makeOperation(at location: Location) -> Operation<OwnedBySwift> {
    if let dialect = dialect {
      return Operation(
        dialect, name,
        attributes: attributes,
        operands: operands,
        resultTypes: resultTypes,
        regions: regions,
        location: location)
    } else {
      return Operation(
        name,
        attributes: attributes,
        operands: operands,
        resultTypes: resultTypes,
        regions: regions,
        location: location)
    }
  }
}

extension BuildableOperation where ResultTypes == () {
  public init(
    _ dialect: Dialect, _ name: String,
    attributes: MLIR.NamedAttributes = [:],
    operands: [MLIR.Value] = [],
    regions: [MLIR.Region<OwnedBySwift>] = [])
  {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = []
    self.regions = regions
  }
  init(
    _ name: String,
    attributes: MLIR.NamedAttributes = [:],
    operands: [MLIR.Value] = [],
    regions: [MLIR.Region<OwnedBySwift>] = [])
  {
    self.dialect = nil
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = []
    self.regions = regions
  }
}

extension BuildableOperation where ResultTypes == (MLIR.`Type`) {
  public init(
    _ dialect: Dialect, _ name: String,
    attributes: MLIR.NamedAttributes = [:],
    operands: [MLIR.Value] = [],
    resultType: MLIR.`Type`,
    regions: [MLIR.Region<OwnedBySwift>] = [])
  {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [resultType]
    self.regions = regions
  }
}


public protocol OperationProtocol {
  var dialect: Dialect { get }
  var name: String { get }
  var attributes: MLIR.NamedAttributes { get }
  var operands: [MLIR.Value] { get }
  var regions: [MLIR.Region<OwnedBySwift>] { get }
  var location: Location { get }
  
  associatedtype ResultTypes
  var resultTypes: ResultTypes { get }
  static func resultTypesArray(from resultTypes: ResultTypes) -> [MLIR.`Type`]
}

extension OperationProtocol {
  public var attributes: MLIR.NamedAttributes { [:] }
  public var operands: [MLIR.Value] { [] }
  public var regions: [MLIR.Region<OwnedBySwift>] { [] }
  
  func makeOperation() -> Operation<OwnedBySwift> {
    Operation(
      dialect, name,
      attributes: attributes,
      operands: operands,
      resultTypes: Self.resultTypesArray(from: resultTypes),
      regions: regions,
      location: location)
  }
}

extension OperationProtocol where ResultTypes == () {
  public static func resultTypesArray(from resultTypes: ResultTypes) -> [MLIR.`Type`] {
    []
  }
}

extension OperationProtocol where ResultTypes == (MLIR.`Type`) {
  public static func resultTypesArray(from resultTypes: ResultTypes) -> [MLIR.`Type`] {
    [resultTypes]
  }
}

extension OperationProtocol where ResultTypes == (MLIR.`Type`, MLIR.`Type`) {
  public static func resultTypesArray(from resultTypes: ResultTypes) -> [MLIR.`Type`] {
    [resultTypes.0, resultTypes.1]
  }
}
