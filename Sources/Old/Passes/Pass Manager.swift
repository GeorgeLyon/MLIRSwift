import CMLIR

public struct Pass: CRepresentable {
  public init(_ cRepresentation: MlirPass) {
    c = cRepresentation
  }
  let c: MlirPass
}

public final class PassManager: CRepresentable {
  public convenience init(context: Context, passes: Pass...) {
    self.init(context: context, passes: Array(passes))
  }
  public init(context: Context, passes: [Pass]) {
    c = mlirPassManagerCreate(context.cRepresentation)
    for pass in passes {
      mlirPassManagerAddOwnedPass(c, pass.c)
    }
  }
  deinit {
    mlirPassManagerDestroy(c)
  }

  public func runPasses(on module: Module) {
    mlirPassManagerRun(c, module.c)
  }

  let c: MlirPassManager
}
