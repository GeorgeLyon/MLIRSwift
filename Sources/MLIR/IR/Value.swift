import CMLIR

public struct Value: CRepresentable, Printable {
  public var type: MLIR.`Type` {
    MLIR.`Type`(c: mlirValueGetType(c))!
  }
  public var context: UnownedContext {
    type.context
  }

  public enum Kind {
    case argument(of: Block)
    case result(of: Operation)
  }
  public var kind: Kind {
    if mlirValueIsABlockArgument(c) {
      return .argument(of: Block(c: mlirBlockArgumentGetOwner(c))!)
    } else if mlirValueIsAOpResult(c) {
      return .result(of: Operation(c: mlirOpResultGetOwner(c))!)
    } else {
      fatalError()
    }
  }
  let c: MlirValue

  static let isNull = mlirValueIsNull
  static let print = mlirValuePrint

  /// Suppress initializer synthesis
  private init() { fatalError() }
}
