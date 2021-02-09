
import CMLIR

public struct Dialect {
  
  public var namespace: String {
    mlirDialectHandleGetNamespace(c).string
  }
  
  /**
   While MLIR does have an `MlirDialect` type, we find that type is not particularly useful, so we promote the vastly more useful `MlirDialectHandle` to `Dialect`. If it ends up being necessary, we can bridge`MlirDialect` as `Dialect.Instance` or something similarc.
   */
  let c: MlirDialectHandle
}
