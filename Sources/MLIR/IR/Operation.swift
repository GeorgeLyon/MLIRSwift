
import CMLIR

public struct Operation<Ownership>: Bridged {
  typealias MlirStruct = MlirOperation
  let storage: Storage
}

// MARK: - Bridging

extension MlirOperation: Bridgable, Destroyable {
  static let destroy = mlirOperationDestroy
  static let areEqual = mlirOperationEqual
  static let isNull = mlirOperationIsNull
}
