
import Utilities

let maxNumArguments = 10

<<"""
extension BuildableOperation
where
  ResultTypes == ()
{
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

extension BuildableOperation
where
  ResultTypes == MLIR.`Type`
{
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
  init(
    _ name: String,
    attributes: MLIR.NamedAttributes = [:],
    operands: [MLIR.Value] = [],
    resultType: MLIR.`Type`,
    regions: [MLIR.Region<OwnedBySwift>] = [])
  {
    self.dialect = nil
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [resultType]
    self.regions = regions
  }
}

"""

for numArguments in 2...maxNumArguments {
  let range = 0...numArguments
  let names = range.map { "t\($0)" }
  let resultTypesArguments = names.map { "\($0): MLIR.`Type`" }.joined(separator: ", _ ")
  let resultTypesValues = names.joined(separator: ", ")
  <<"""

  extension BuildableOperation
  where
    ResultTypes == (\(range.map { _ in "MLIR.`Type`" }.joined(separator: ", ")))
  {

    public init(
      _ dialect: Dialect, _ name: String,
      attributes: MLIR.NamedAttributes = [:],
      operands: [MLIR.Value] = [],
      resultTypes \(resultTypesArguments),
      regions: [MLIR.Region<OwnedBySwift>] = [])
    {
      self.dialect = dialect
      self.name = name
      self.attributes = attributes
      self.operands = operands
      self.resultTypes = [\(resultTypesValues)]
      self.regions = regions
    }

    init(
      _ name: String,
      attributes: MLIR.NamedAttributes = [:],
      operands: [MLIR.Value] = [],
      resultTypes \(resultTypesArguments),
      regions: [MLIR.Region<OwnedBySwift>] = [])
    {
      self.dialect = nil
      self.name = name
      self.attributes = attributes
      self.operands = operands
      self.resultTypes = [\(resultTypesValues)]
      self.regions = regions
    }

  }
  """
}
