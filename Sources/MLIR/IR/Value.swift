import CMLIR

public struct Value: OpaqueStorageRepresentable {
  let storage: BridgingStorage<MlirValue, OwnedByMLIR>
  
  public var type: MLIR.`Type` {
    .borrow(mlirValueGetType(.borrow(self)))!
  }
}

extension MlirValue: Bridged {}
