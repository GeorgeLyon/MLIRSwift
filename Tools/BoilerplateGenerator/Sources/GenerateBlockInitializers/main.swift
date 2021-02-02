
import Utilities

let maxNumArguments = 10

<<"""
extension Block {
"""
increaseIndentation()
for numArguments in 0...maxNumArguments {
  let range = 0...numArguments
  let names = range.map { "t\($0)" }
  <<"""
  public init(
    \(names.map { "_ \($0): Type" }.joined(separator: ", ")),
    operations: (inout OperationBuilder, \(range.map { _ in "MLIR.Value" }.joined(separator: ", "))) throws -> Void) rethrows
  where
    Ownership == OwnedBySwift
  {
    try self.init(argumentTypes: [\(names.joined(separator: ", "))], operations: { builder, arguments in
      try operations(&builder, \(range.map { "arguments[\($0)]" }.joined(separator: ", ")))
    })
  }

  """
}
decreaseIndentation()
<<"""
}
"""
