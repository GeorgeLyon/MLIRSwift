
import CMLIR

public final class Context {
  
  public init(_ dialects: Dialect...) {
    c = mlirContextCreate()
    for dialect in dialects {
      _ = mlirDialectHandleLoadDialect(dialect.c, c)
    }
  }
  
  init(c: MlirContext) {
    self.c = c
  }
  deinit {
    mlirContextDestroy(c)
  }
  let c: MlirContext
}
