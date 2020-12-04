
import CMLIR

public struct RegisteredDialect<MLIR> {
  let metadata: DialectMetadata
}

public struct DialectMetadata {
  public init(
    register: @escaping (MlirContext) -> Void,
    load: @escaping (MlirContext) -> MlirDialect,
    getNamespace: @escaping () -> MlirStringRef)
  {
    self.register = register
    self.load = load
    self.getNamespace = getNamespace
  }
  public static func of<MLIR>(_ dialect: RegisteredDialect<MLIR>) -> Self {
    return dialect.metadata
  }
  public func register<MLIR>(with mlir: MLIR.Type) -> RegisteredDialect<MLIR> {
    return RegisteredDialect(metadata: self)
  }
  public let register: (MlirContext) -> Void
  public let load: (MlirContext) -> MlirDialect
  public let getNamespace: () -> MlirStringRef
}
