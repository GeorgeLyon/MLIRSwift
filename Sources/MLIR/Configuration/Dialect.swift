import CMLIR

extension MLIR {
  public static func load(_ dialects: Dialect...) {
    for dialect in dialects {
      _ = dialect.hooks.loadHook(context)
    }
  }
}

public struct Dialect {
  /**
   In the future, we hope the C bindings will provide a type that encapsulates this data
   */
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
