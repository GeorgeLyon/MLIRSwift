
import Utilities

let maxNumArguments = 10

for numArguments in 2...maxNumArguments {
  let range = 0..<numArguments
  let names = range.map { "t\($0)" }
  <<"""

  // \(numArguments) results
  extension Operation.Definition where Results == (\(range.map { _ in "Value" }.joined(separator: ", "))) {
    
    public init(
      _ dialect: Dialect, _ name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      resultTypes \(names.map { "\($0): MLIR.`Type`" }.joined(separator: ", _ ")),
      ownedRegions: [Region] = [])
    {
      self.dialect = dialect
      self.name = name
      self.attributes = attributes
      self.operands = operands
      self.resultTypes = [\(names.joined(separator: ", "))]
      self.ownedRegions = ownedRegions
    }
    
    public init(
      _ dialect: Dialect, _ name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      resultTypes _: \(
        range.map { _ in "Operation.InferredResultType" }.joined(separator: ", _: ")),
      ownedRegions: [Region] = [])
    {
      self.dialect = dialect
      self.name = name
      self.attributes = attributes
      self.operands = operands
      self.resultTypes = nil
      self.ownedRegions = ownedRegions
    }
    
  }

  """
}
