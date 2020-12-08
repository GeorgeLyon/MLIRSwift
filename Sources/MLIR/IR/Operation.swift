
import CMLIR

public struct Operation<Ownership>: OpaqueStorageRepresentable {
  let storage: BridgingStorage<MlirOperation, Ownership>
}

// MARK: - Bridging

extension MlirOperation: Bridged, Destroyable {
  typealias Pointer = UnsafeMutableRawPointer
  typealias SwiftRepresentation = Operation
  static let destroy = mlirOperationDestroy
  static let areEqual = mlirOperationEqual
  static let isNull = mlirOperationIsNull
}
