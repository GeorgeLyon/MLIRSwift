
import Utilities

let maxNumArguments = 10

<<"""
extension Block.Operations {

"""
for numArguments in 1...maxNumArguments {
  let range = 0..<numArguments
  let values = range.map { _ in "Value" }.joined(separator: ", ")
  <<"""

  /**
   Appends an operation with \(numArguments) results and returns the results
   */
  public func append(_ operation: Operation<(\(values))>) -> (\(values)) {
    append(operation.typeErased)
    return operation.results
  }

  """
}
<<"}"
