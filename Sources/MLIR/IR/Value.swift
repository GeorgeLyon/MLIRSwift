import CMLIR

public struct Value: CRepresentable, Printable {
  public var type: MLIR.`Type` {
    MLIR.`Type`(c: mlirValueGetType(c))!
  }
  let c: MlirValue

  static let isNull = mlirValueIsNull
  static let print = mlirValuePrint

  /// Suppress initializer synthesis
  private init() { fatalError() }
}
