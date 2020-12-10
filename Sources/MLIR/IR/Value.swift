
import CMLIR

public struct Value<MLIR: MLIRConfiguration>: OpaqueStorageRepresentable {
  public var type: MLIR.`Type` {
    .borrow(mlirValueGetType(.borrow(self)))!
  }
  let storage: BridgingStorage<MlirValue, OwnedByMLIR>
}

extension MlirValue: Bridged { }
