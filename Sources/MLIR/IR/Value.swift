
import CMLIR

public struct Value<MLIR: MLIRConfiguration>: OpaqueStorageRepresentable {
  let storage: BridgingStorage<MlirValue, OwnedByMLIR>
}

extension MlirValue: Bridged { }
