
import Utilities

let maxNumResults = 10

for numResults in 0...maxNumResults {
  let range = 0..<numResults
  let names = range.map { "t\($0)" }
  let resultTypes = range.map { _ in "MLIR.`Type`" }.joined(separator: ", ")
  let results = range.map { _ in "MLIR.Value" }.joined(separator: ", ")
  <<"""
  public extension OperationProtocol where ResultTypes == (\(resultTypes)) {
    static func types(of resultTypes: ResultTypes) -> [MLIR.`Type`] {
      let (\(names.joined(separator: ", "))) = resultTypes
      return [\(names.joined(separator: ", "))]
    }
    static func results(from operationResults: MLIR.Operation<OwnedBySwift>.Results) -> (\(results)) {
      (\(range.map { "operationResults[\($0)]" }.joined(separator: ", ")))
    }
  }

  """
}
