
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
  public func append(_ operation: TypedOperation<(\(values))>) -> (\(values)) {
    append(operation as OperationProtocol)
    let results = operation.results
    precondition(results.count == \(numArguments))
    return (\(range.map { "results[\($0)]" }.joined(separator: ", ")))
  }

  """
}
<<"}"
