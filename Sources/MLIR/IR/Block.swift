
import CMLIR

public extension MLIRConfiguration {
  typealias Block<T: Ownership> = MLIR.Block<Self, T>
}

public struct Block<MLIR: MLIRConfiguration, Ownership: MLIR.Ownership>: OpaqueStorageRepresentable {
  public init(
    arguments: [MLIR.`Type`] = [],
    operations: [Operation<OwnedBySwift>] = [])
  where
    Ownership == OwnedBySwift
  {
    let c = arguments.withUnsafeBridgedValues { arguments in
      mlirBlockCreate(arguments.count, arguments.baseAddress)
    }
    /// `mlirBlockCreate` should never fail
    self = .assumeOwnership(of: c)!
    operations.forEach(append)
  }
  
  public struct Operations: Collection, LinkedList {
    public typealias Element = Operation<OwnedByMLIR>
    public struct Index: Comparable, OpaqueStorageRepresentable {
      let storage: LinkedListIndexStorage<MlirOperation>
      public static func <(lhs: Self, rhs: Self) -> Bool { lhs.storage < rhs.storage }
    }
    var first: MlirOperation { mlirBlockGetFirstOperation(c) }
    static var next: (MlirOperation) -> MlirOperation { mlirOperationGetNextInBlock }
    fileprivate let c: MlirBlock
  }
  public var operations: Operations { Operations(c: bridgedValue()) }
  
  /**
   Assumes ownership of `operation`
   */
  public func append(_ operation: Operation<OwnedBySwift>) {
    mlirBlockAppendOwnedOperation(bridgedValue(), .assumeOwnership(of: operation))
  }
  
  typealias MlirStruct = MlirBlock
  init(storage: BridgingStorage<MlirBlock, Ownership>) { self.storage = storage }
  let storage: BridgingStorage<MlirBlock, Ownership>
}

// MARK: - Bridging

extension MlirBlock: Bridged, Destroyable {
  static let destroy = mlirBlockDestroy
  static let areEqual = mlirBlockEqual
  static let isNull = mlirBlockIsNull
}
