import CMLIR

/**
 An object which manages a pass pipeline
 */
public final class PassManager {
  public convenience init(context: Context, passes: Pass...) {
    self.init(context: context, passes: Array(passes))
  }
  public init(context: Context, passes: [Pass]) {
    mlir = mlirPassManagerCreate(context.mlir)
    for pass in passes {
      mlirPassManagerAddOwnedPass(mlir, pass.build())
    }
  }
  deinit {
    mlirPassManagerDestroy(mlir)
  }

  public func runPasses(on module: Module) {
    mlirPassManagerRun(mlir, module.mlir)
  }

  let mlir: MlirPassManager
}
