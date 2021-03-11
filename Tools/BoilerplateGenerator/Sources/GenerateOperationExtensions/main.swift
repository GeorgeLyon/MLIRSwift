
import Utilities

let maxNumResults = 10

for numResults in 2...maxNumResults {
  let range = 0..<numResults
  let names = range.map { "t\($0)" }
  <<"""

  // \(numResults) results
  extension Operation where Results == (\(range.map { _ in "Value" }.joined(separator: ", "))) {
    
    public init(
      _ dialect: Dialect, _ name: String,
      attributes: [NamedAttribute] = [],
      operands: [Value] = [],
      resultTypes \(names.map { "\($0): Type" }.joined(separator: ", _ ")),
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
        range.map { _ in "InferredResultType" }.joined(separator: ", _: ")),
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
  
    public var results: Results {
      let results = typeErased.results
      precondition(results.count == \(numResults))
      return (\(range.map { "results[\($0)]" }.joined(separator: ", ")))
    }

  }

  """
}
