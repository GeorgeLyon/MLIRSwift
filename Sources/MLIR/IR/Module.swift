
import CMLIR

public final class Module: Parsable {
  public convenience init(context: Context, location: Location) {
    self.init(c: mlirModuleCreateEmpty(location.c))!
  }
  
  /// `Module` is not `CRepresentable` because it is a `class`
  init?(c: MlirModule) {
    guard !mlirModuleIsNull(c) else {
      return nil
    }
    self.c = c
  }
  deinit {
    mlirModuleDestroy(c)
  }
  let c: MlirModule
  
  static let parse = mlirModuleCreateParse
}
