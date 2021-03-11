
import Utilities

let maxNumArguments = 10
<<"""

extension Block {

/// 0 arguments
public init(
  buildOperations: (Block.Operations) throws -> Void
) rethrows {
  self.init(argumentTypes: [])
  try buildOperations(operations)
}

"""

for numArguments in 1...maxNumArguments {
  let range = 0..<numArguments
  let names = range.map { "t\($0)" }
  <<"""
  /// \(numArguments) arguments
  public init(
    \(names.map { "_ \($0): Type" }.joined(separator: ", ")),
    buildOperations: (Block.Operations, \(range.map { _ in "Value" }.joined(separator: ", "))) throws -> Void
  ) rethrows {
    self.init(argumentTypes: [\(names.joined(separator: ", "))])
    try buildOperations(operations, \(range.map { "arguments[\($0)]" }.joined(separator: ", ")))
  }

  """
}
<<"}"
