
import CMLIR

public struct Type: CRepresentable {
  public var context: Context {
    Context(c: mlirTypeGetContext(c))
  }
  
  let c: MlirType
  
  static let isNull = mlirTypeIsNull
  
  /// Suppress initializer synthesis
  private init() { fatalError() }
}
