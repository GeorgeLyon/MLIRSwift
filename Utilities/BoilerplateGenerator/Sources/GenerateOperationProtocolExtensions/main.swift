
import Utilities

let maximumNumberOfVariadicArguments = 10

for numberOfVariadicArguments in 0...maximumNumberOfVariadicArguments {
  let range = 0..<numberOfVariadicArguments
  <<"""
  extension OperationProtocol where Results == (\(range.map { _ in "MLIR.Value" }.joined(separator: ", "))) {
    public static func results(from operation: Operation) -> Results {
      (\(range.map { "operation.results[\($0)]" }.joined(separator: ", ")))
    }
  }

  extension OperationProtocol where Results == (\(range.map { _ in "MLIR.Value" }.joined(separator: ", "))) {
    public static func results(from operation: Operation) -> Results {
      (\(range.map { "operation.results[\($0)]" }.joined(separator: ", ")))
    }
  }

  """
}
