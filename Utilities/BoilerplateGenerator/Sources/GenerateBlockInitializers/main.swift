
import Utilities

let maxNumArguments = 10

<<"""
extension Block {
  public init(
    operations: (inout MLIR.Operation<OwnedBySwift>.Builder) -> Void)
  where
    Ownership == OwnedBySwift
  {
    self = Block(argumentTypes: [])
    var builder = MLIR.Operation<OwnedBySwift>.Builder()
    operations(&builder)
    builder.operations.forEach(self.operations.append)
  }
"""
increaseIndentation()
for numArguments in 0...maxNumArguments {
  let range = 0...numArguments
  let names = range.map { "t\($0)" }
  <<"""

  public init(
    \(names.map { "_ \($0): MLIR.`Type`" }.joined(separator: ", ")),
    operations: (inout MLIR.Operation<OwnedBySwift>.Builder, \(range.map { _ in "MLIR.Value" }.joined(separator: ", "))) -> Void)
  where
    Ownership == OwnedBySwift
  {
    self = Block(argumentTypes: [\(names.joined(separator: ", "))])
    var builder = MLIR.Operation<OwnedBySwift>.Builder()
    operations(&builder, \(range.map { "arguments[\($0)]" }.joined(separator: ", ")))
    builder.operations.forEach(self.operations.append)
  }
  """
}
decreaseIndentation()
<<"""

}
"""
