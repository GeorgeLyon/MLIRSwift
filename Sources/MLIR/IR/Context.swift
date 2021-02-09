
import CMLIR

public protocol Context {
  var cRepresentation: MlirContext { get }
}

public final class OwnedContext: Context {
  public init(dialects: Dialect...) {
    c = mlirContextCreate()
    for dialect in dialects {
      _ = mlirDialectHandleLoadDialect(dialect.c, c)
    }
  }
  public var cRepresentation: MlirContext { c }
  
  deinit {
    mlirContextDestroy(c)
  }
  let c: MlirContext
}

public struct UnownedContext: Context, CRepresentable {
  public var cRepresentation: MlirContext { c }
  let c: MlirContext
  
  static let isNull = mlirContextIsNull
  
  /// Suppress initializer synthesis
  private init() { fatalError() }
}
