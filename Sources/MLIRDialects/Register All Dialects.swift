
import CMLIRDialects
import MLIR

extension Context {
  public init(registerAllDialects: Bool) {
    self.init(dialects: [])
    if registerAllDialects {
      mlirRegisterAllDialects(c)
    }
  }
}
