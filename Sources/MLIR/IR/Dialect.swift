
import CMLIR

/**
 The Swift representation of an MLIR dialect
 */
public struct Dialect {

  /**
   Creates a `Dialect` from an `MlirDialectHandle`
   
   - note: While MLIR does have an `MlirDialect` type, we find that type is not particularly useful, so we choose not to provide a Swift analog. This frees up the name `Dialect` to be used as an analog to `MlirDialectHandle`. If it is needed in the future, we can create a Swift analog for `MlirDialect` with a name like `Dialect.Instance`.
   */
  public init(_ handle: MlirDialectHandle) {
    self.mlir = handle
  }

  /**
   The namespace associated with this dialect
   */
  public var namespace: String {
    mlirDialectHandleGetNamespace(mlir).string
  }

  let mlir: MlirDialectHandle
}
