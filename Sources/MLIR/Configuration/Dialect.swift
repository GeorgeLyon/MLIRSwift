import CMLIR

extension MLIR {
  public static func load(_ dialects: Dialect...) {
    for dialect in dialects {
      _ = dialect.hooks.loadHook(context)
    }
  }
}

public struct Dialect {
  public init(_ fn: () -> UnsafePointer<MlirDialectRegistrationHooks>?) {
    self.hooks = fn()!.pointee
  }
  public var namespace: String {
    hooks.getNamespaceHook().string
  }
  fileprivate let hooks: MlirDialectRegistrationHooks
}

extension MlirDialect: Bridged {
  static let areEqual = mlirDialectEqual
  static let isNull = mlirDialectIsNull
}
