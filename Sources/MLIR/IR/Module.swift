import CMLIR

public final class Module: Parsable {
  public convenience init(location: Location) {
    self.init(c: mlirModuleCreateEmpty(location.c))!
  }

  public var body: Block {
    Block(c: mlirModuleGetBody(c))!
  }
  public var operation: Operation {
    Operation(c: mlirModuleGetOperation(c))!
  }

  public var cRepresentation: MlirModule { c }

  /// `Module` is not `CRepresentable` because it is a `class`
  init?(c: MlirModule) {
    guard !mlirModuleIsNull(c) else {
      return nil
    }
    self.c = c
  }
  deinit {
    mlirModuleDestroy(c)
  }
  let c: MlirModule

  static let parse = mlirModuleCreateParse
}
