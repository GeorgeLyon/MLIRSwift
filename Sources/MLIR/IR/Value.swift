
import CMLIR

public struct Value: CRepresentable {
  public var type: MLIR.`Type` {
    MLIR.`Type`(c: mlirValueGetType(c))!
  }
  let c: MlirValue
  
  static let isNull = mlirValueIsNull
  
  /// Suppress initializer synthesis
  private init() { fatalError() }
}

