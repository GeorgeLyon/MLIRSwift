
import CMLIR

public struct Pass: CRepresentable {
  public init(_ cRepresentation: MlirPass) {
    c = cRepresentation
  }
  let c: MlirPass
}

public struct PassManager: CRepresentable {
  public init(context: Context, passes: Pass...) {
    self.init(context: context, passes: Array(passes))
  }
  public init(context: Context, passes: [Pass]) {
    c = mlirPassManagerCreate(context.c)
    for pass in passes {
      mlirPassManagerAddOwnedPass(c, pass.c)
    }
  }
  public func destroy() {
    mlirPassManagerDestroy(c)
  }
  
  public func runPasses(on module: Module) {
    mlirPassManagerRun(c, module.c)
  }
  
  let c: MlirPassManager
}
