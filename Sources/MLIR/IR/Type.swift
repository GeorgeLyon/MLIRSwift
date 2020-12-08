
import CMLIR

public struct Type: Bridged {
  typealias Ownership = OwnedByMLIR
  typealias MlirStruct = MlirType
  let storage: Storage
}

// MARK: - Bridging

extension MlirType: Bridgable {
  static let areEqual = mlirTypeEqual
  static let isNull = mlirTypeIsNull
}
