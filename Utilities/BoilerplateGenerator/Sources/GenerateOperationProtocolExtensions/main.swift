
import Utilities

let maxNumResults = 10

for numResults in 0...maxNumResults {
  let range = 0..<numResults
  <<"""
  extension OperationProtocol where Results == (\(range.map { _ in "MLIR.Value" }.joined(separator: ", "))) {
    public static func results(from operation: Operation) -> Results {
      (\(range.map { "operation.results[\($0)]" }.joined(separator: ", ")))
    }
  }

  """
}
