import CMLIR

extension MLIR {
  public static func load(_ dialects: Dialect...) {
    for dialect in dialects {
      _ = dialect.loadHook(context)
    }
  }
}

public struct Dialect {
  public init(
    loadHook: @escaping MlirContextLoadDialectHook,
    getNamespace: MlirDialectGetNamespaceHook
  ) {
    self.loadHook = loadHook
    namespace = getNamespace().string
  }
  public let namespace: String
  fileprivate let loadHook: MlirContextLoadDialectHook
}

extension MlirDialect: Bridged {
  static let areEqual = mlirDialectEqual
  static let isNull = mlirDialectIsNull
}
