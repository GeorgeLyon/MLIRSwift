import CMLIR

extension MLIR {
  public static func load(_ dialects: Dialect...) {
    for dialect in dialects {
      mlirDialectHandleLoadDialect(dialect.handle, context)
    }
  }
}

public struct Dialect {
  public init(_ handle: MlirDialectHandle) {
    self.handle = handle
  }
  public var namespace: String {
    mlirDialectHandleGetNamespace(handle).string
  }
  fileprivate let handle: MlirDialectHandle
}

extension MlirDialect: Bridged {
  static let areEqual = mlirDialectEqual
  static let isNull = mlirDialectIsNull
}
