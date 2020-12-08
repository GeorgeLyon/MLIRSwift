
import CMLIR

public struct Type: OpaqueStorageRepresentable {
  let storage: BridgingStorage<MlirType, OwnedByMLIR>
}

// MARK: - Bridging

extension MlirType: Bridged {
  static let areEqual = mlirTypeEqual
  static let isNull = mlirTypeIsNull
}
