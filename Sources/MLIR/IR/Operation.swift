
import CMLIR

public struct Operation<Ownership>: OwnershipSemantics {
  let c: MlirOperation
  let ownership: Ownership
}

// MARK: - Bridging

extension MlirOperation: Destroyable {
  static let destroy = mlirOperationDestroy
}
