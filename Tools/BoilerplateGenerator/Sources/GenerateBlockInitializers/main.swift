
import Utilities

let maxNumArguments = 10

<<"""
extension Block {
  public init(
    operations: (inout OperationBuilder<MLIR>) throws -> Void) rethrows
  where
    Ownership == OwnedBySwift
  {
    self = Block(argumentTypes: [])
    try OperationBuilder.build(operations).forEach(self.operations.append)
  }

"""
increaseIndentation()
for numArguments in 0...maxNumArguments {
  let range = 0...numArguments
  let names = range.map { "t\($0)" }
  <<"""
  public init(
    \(names.map { "_ \($0): Type<MLIR>" }.joined(separator: ", ")),
    operations: (inout OperationBuilder<MLIR>, \(range.map { _ in "MLIR.Value" }.joined(separator: ", "))) throws -> Void) rethrows
  where
    Ownership == OwnedBySwift
  {
    self = Block(argumentTypes: [\(names.joined(separator: ", "))])
    try OperationBuilder.build { builder in
      try operations(&builder, \(range.map { "arguments[\($0)]" }.joined(separator: ", ")))
    }
    .forEach(self.operations.append)
  }

  """
}
decreaseIndentation()
<<"""
}
"""
