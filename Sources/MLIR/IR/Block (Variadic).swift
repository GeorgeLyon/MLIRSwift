
extension Block {
  public init(
    _ t0: MLIR.`Type`,
    operations: (inout MLIR.Operation<OwnedBySwift>.Builder, MLIR.Value) -> Void)
  where
    Ownership == OwnedBySwift
  {
    self = Block(argumentTypes: [t0])
    var builder = MLIR.Operation<OwnedBySwift>.Builder()
    operations(&builder, arguments[0])
  }
}
