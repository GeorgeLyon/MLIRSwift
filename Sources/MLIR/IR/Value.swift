import CMLIR

public struct Value: MlirRepresentable {

  public init(_ mlir: MlirValue) {
    self.init(mlir: mlir)
  }
  public let mlir: MlirValue

  public var type: MLIR.`Type` {
    Type(mlirValueGetType(mlir))
  }
  public var context: UnownedContext {
    type.context
  }

  public enum Kind {
    case argument(of: Block)
    case result(of: AnyOperation)
  }
  public var kind: Kind {
    if mlirValueIsABlockArgument(mlir) {
      return .argument(of: Block(mlirBlockArgumentGetOwner(mlir)))
    } else if mlirValueIsAOpResult(mlir) {
      return .result(of: AnyOperation(mlirOpResultGetOwner(mlir)))
    } else {
      fatalError()
    }
  }

  public var block: Block? {
    switch kind {
    case .argument(of: let block): return block
    case .result(of: let operation): return operation.owningBlock
    }
  }

  /// Suppress initializer synthesis
  private init() { fatalError() }
}
