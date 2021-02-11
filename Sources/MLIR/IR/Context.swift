import CMLIR

public struct Context: CRepresentable {
  
  public init(dialects: Dialect...) {
    c = mlirContextCreate()
    for dialect in dialects {
      _ = mlirDialectHandleLoadDialect(dialect.c, c)
    }
  }
  public func destroy() {
    mlirContextDestroy(c)
  }
  
  public var cRepresentation: MlirContext { c }
  let c: MlirContext

  static let isNull = mlirContextIsNull

  /// Suppress initializer synthesis
  private init() { fatalError() }
}
