
import CMLIR

public struct Value: CRepresentable {
  
  let c: MlirValue
  
  static let isNull = mlirValueIsNull
  
  /// Suppress initializer synthesis
  private init() { fatalError() }
}

