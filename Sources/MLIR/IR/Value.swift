
import CMLIR

public extension MLIRConfiguration {
  typealias Value = MLIR.Value<Self>
}

public struct Value<MLIR: MLIRConfiguration>: MlirStructWrapper, MlirStringCallbackStreamable {
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirValuePrint(c, unsafeCallback, userData)
  }
  let c: MlirValue
}
