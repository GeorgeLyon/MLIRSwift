
import Utilities

let maxNumArguments = 10

<<"""
extension Block.Operations {

"""
for numArguments in 0...maxNumArguments {
  let range = 0..<numArguments
  let values = range.map { _ in "Value" }.joined(separator: ", ")
  <<"""

  /// Appends an operation with \(numArguments) results
  public func append(_ definition: Operation.Definition<(\(values))>, at location: Location) -> (\(values)) {
    let operation = Operation(definition, location: location)!
    append(operation)
    let results = operation.results
    precondition(results.count == \(numArguments))
    return (\(range.map { "results[\($0)]" }.joined(separator: ", ")))
  }

  """
}
<<"}"
