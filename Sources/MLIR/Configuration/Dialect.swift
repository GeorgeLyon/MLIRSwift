import CMLIR

extension MLIR {
  public static func register(_ dialects: Dialect...) {
    for dialect in dialects {
      dialect.register(context)
    }
  }
}

public struct Dialect {
  /**
   In the future, we hope the C bindings will provide a type that encapsulates this data
   */
  public init(
    register: @escaping (MlirContext) -> Void,
    getNamespace: @escaping () -> MlirStringRef
  ) {
    self.register = register
    self.getNamespace = getNamespace
  }
  public var namespace: String {
    return getNamespace().string
  }
  private let getNamespace: () -> MlirStringRef
  fileprivate let register: (MlirContext) -> Void
}

extension MlirDialect: Bridged {
  static let areEqual = mlirDialectEqual
  static let isNull = mlirDialectIsNull
}
