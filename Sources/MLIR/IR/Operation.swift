
import CMLIR

public extension MLIR.MLIRConfiguration {
  typealias Operation<Ownership: MLIR.Ownership> = MLIR.Operation<Self, Ownership>
}

public struct Operation<MLIR: MLIRConfiguration, Ownership: MLIR.Ownership>: OpaqueStorageRepresentable {
  
  public struct Regions: RandomAccessCollection {
    public let startIndex = 0
    public var endIndex: Int { mlirOperationGetNumRegions(c)}
    public subscript(position: Int) -> MLIR.Region<OwnedByMLIR> {
      .borrow(mlirOperationGetRegion(c, position))!
    }
    fileprivate let c: MlirOperation
  }
  public var regions: Regions { Regions(c: borrowedValue()) }
  
  init(storage: BridgingStorage<MlirOperation, Ownership>) { self.storage = storage }
  let storage: BridgingStorage<MlirOperation, Ownership>
}

// MARK: - Bridging

extension MlirOperation: Bridged, CEquatable, Destroyable {
  typealias Pointer = UnsafeMutableRawPointer
  typealias SwiftRepresentation = Operation
  static let destroy = mlirOperationDestroy
  static let areEqual = mlirOperationEqual
  static let isNull = mlirOperationIsNull
}
