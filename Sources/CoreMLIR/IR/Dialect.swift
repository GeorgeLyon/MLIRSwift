
import CCoreMLIR

public struct Dialect {
  public init(
    register: @escaping (MlirContext) -> Void,
    load: @escaping (MlirContext) -> MlirDialect,
    getNamespace: @escaping () -> MlirStringRef)
  {
    self.register = register
    self.load = load
    self.getNamespace = getNamespace
  }
  
  public struct Instance: MlirStructWrapper {
    let c: MlirDialect
  }
  
  public var namespace: String {
    getNamespace().string
  }
  
  let register: (MlirContext) -> Void
  let load: (MlirContext) -> MlirDialect
  let getNamespace: () -> MlirStringRef
}
