
import CMLIR

public final class Module {
  public convenience init(context: Context, location: Location) {
    self.init(c: mlirModuleCreateEmpty(location.c))
  }
  
  init(c: MlirModule) {
    self.c = c
  }
  deinit {
    mlirModuleDestroy(c)
  }
  let c: MlirModule
}
