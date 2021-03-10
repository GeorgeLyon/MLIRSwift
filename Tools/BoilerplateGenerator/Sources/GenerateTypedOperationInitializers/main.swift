
import Utilities

let maxNumArguments = 10

for numArguments in 2...maxNumArguments {
  let range = 0..<numArguments
  let names = range.map { "t\($0)" }
  <<"""

  // \(numArguments) results
  extension OperationProtocol where Self == TypedOperation<(\(range.map { _ in "Value" }.joined(separator: ", ")))> {
    
    public init(
      _ dialect: Dialect, _ name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      resultTypes \(names.map { "\($0): MLIR.`Type`" }.joined(separator: ", _ ")),
      ownedRegions: [Region] = [],
      location: Location
    ) {
      self.init(
        dialect: dialect,
        name: name,
        attributes: attributes,
        operands: operands,
        resultTypes: [\(names.joined(separator: ", "))],
        ownedRegions: ownedRegions,
        location: location)
    }

    public init(
      _ dialect: Dialect, _ name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      resultTypes _: \(
        range.map { _ in "Self.InferredResultType" }.joined(separator: ", _: ")),
      ownedRegions: [Region] = [],
      location: Location
    ) {
      self.init(
        dialect: dialect,
        name: name,
        attributes: attributes,
        operands: operands,
        resultTypes: nil,
        ownedRegions: ownedRegions,
        location: location)
    }

  }

  """
}
