import CMLIR

/**
 An object which owns simpler objects like `Type` and `Location`. Objects **must not** be used after the owning context is destroyed (this will result in undefined behavior).

 The main difference between the two types of context (`OwnedContext` and `UnownedContext`) is that `OwnedContext` is a class which destroys the context on deinitialization.
 */
public protocol Context {
  var mlir: MlirContext { get }
}

public func == (lhs: Context, rhs: Context) -> Bool {
  mlirContextEqual(lhs.mlir, rhs.mlir)
}

/**
 A context which destroys itself on deinitialization.
 */
public final class OwnedContext: Context {

  /**
   Creates a context loaded with the specified dialects
   */
  public init(dialects: Dialect...) {
    mlir = mlirContextCreate()
    for dialect in dialects {
      _ = mlirDialectHandleLoadDialect(dialect.mlir, mlir)
    }
  }
  deinit {
    mlirContextDestroy(mlir)
  }

  public var mlir: MlirContext
}

/**
 A context which is owned by MLIR
 */
public struct UnownedContext: Context, MlirRepresentable {
  public var mlir: MlirContext

  /// Suppress synthesized initializer
  private init() { fatalError() }
}
