
import Utilities

let maxNumArguments = 10

<<"""
extension Block.Operations {

"""
increaseIndentation()
for numArguments in 0...maxNumArguments {
  let range = 0..<numArguments
  <<"""
  public func append(_ op: BuildableOperation<(\(range.map { _ in "MLIR.`Type`" }.joined(separator: ", ")))>, at location: Location) -> (\(range.map { _ in "MLIR.Value" }.joined(separator: ", ")))
  {
    let operation = append(op.makeOperation(at: location))
    let results = operation.results
    assert(results.count == \(numArguments))
    return (\(range.map { "results[\($0)]" }.joined(separator: ", ")))
  }

  """
}
decreaseIndentation()
<<"}"
