import CMLIR

extension MLIR {
  public static func load(_ dialects: Dialect...) {
    for dialect in dialects {
      _ = dialect.load(context)
    }
  }
}

public struct Dialect {
  public init(
    load: @escaping MlirContextLoadDialectHook,
    getNamespace: MlirDialectGetNamespaceHook
  ) {
    self.load = load
    self.namespace = getNamespace().string
  }
  public let namespace: String
  fileprivate let load: MlirContextLoadDialectHook
}

extension MlirDialect: Bridged {
  static let areEqual = mlirDialectEqual
  static let isNull = mlirDialectIsNull
}
