
import Utilities

let maxNumArguments = 10

<<"""
extension Block where Ownership == OwnedBySwift {
"""
increaseIndentation()
for numArguments in 0...maxNumArguments {
  let range = 0...numArguments
  let names = range.map { "t\($0)" }
  <<"""
  public init(
    \(names.map { "_ \($0): Type" }.joined(separator: ", ")),
    buildOperations: (Block.Operations, \(range.map { _ in "MLIR.Value" }.joined(separator: ", "))) throws -> Void) rethrows
  {
    self.init(argumentTypes: [\(names.joined(separator: ", "))])
    try buildOperations(operations, \(range.map { "arguments[\($0)]" }.joined(separator: ", ")))
  }

  """
}
decreaseIndentation()
<<"""
}
"""
