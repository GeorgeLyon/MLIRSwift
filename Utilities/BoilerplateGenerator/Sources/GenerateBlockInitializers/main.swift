
import Utilities

let maxNumArguments = 10

<<"""
extension Block {
  public init(
    operations: (inout MLIR.Operation<OwnedBySwift>.Builder) throws -> Void) rethrows
  where
    Ownership == OwnedBySwift
  {
    self = Block(argumentTypes: [])
    var builder = MLIR.Operation<OwnedBySwift>.Builder()
    try operations(&builder)
    builder.operations.forEach(self.operations.append)
  }

"""
increaseIndentation()
for numArguments in 0...maxNumArguments {
  let range = 0...numArguments
  let names = range.map { "t\($0)" }
  <<"""
  public init(
    \(names.map { "_ \($0): Type<MLIR>" }.joined(separator: ", ")),
    operations: (inout MLIR.Operation<OwnedBySwift>.Builder, \(range.map { _ in "MLIR.Value" }.joined(separator: ", "))) throws -> Void) rethrows
  where
    Ownership == OwnedBySwift
  {
    self = Block(argumentTypes: [\(names.joined(separator: ", "))])
    var builder = MLIR.Operation<OwnedBySwift>.Builder()
    try operations(&builder, \(range.map { "arguments[\($0)]" }.joined(separator: ", ")))
    builder.operations.forEach(self.operations.append)
  }

  """
}
decreaseIndentation()
<<"""
}
"""
