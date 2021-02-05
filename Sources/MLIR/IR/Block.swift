import CMLIR

public struct Block<Ownership: MLIR.Ownership>: OpaqueStorageRepresentable {
  public init(argumentTypes: [MLIR.`Type`] = [])
  where
    Ownership == OwnedBySwift
  {
    self = argumentTypes.withUnsafeBorrowedValues {
      .assumeOwnership(of: mlirBlockCreate($0.count, $0.baseAddress))!
    }
  }

  public struct Arguments: RandomAccessCollection {
    public let startIndex = 0
    public var endIndex: Int { mlirBlockGetNumArguments(c) }
    public subscript(position: Int) -> MLIR.Value {
      .borrow(mlirBlockGetArgument(c, position))
    }
    public func add(_ type: MLIR.`Type`) -> MLIR.Value {
      .borrow(mlirBlockAddArgument(c, .borrow(type)))
    }
    fileprivate let c: MlirBlock
  }
  public var arguments: Arguments { Arguments(c: .borrow(self)) }

  public struct Operations: Collection, LinkedList {
    public typealias Element = MLIR.Operation<OwnedByMLIR>
    public struct Index: Comparable, OpaqueStorageRepresentable {
      let storage: LinkedListIndexStorage<MlirOperation>
      public static func < (lhs: Self, rhs: Self) -> Bool { lhs.storage < rhs.storage }
    }

    /**
     Returns a representation of this operation which is owned by MLIR, since the passed in value will be invalidated.
     */
    @discardableResult
    public func append(_ operation: MLIR.Operation<OwnedBySwift>) -> MLIR.Operation<OwnedByMLIR> {
      let ownedOperation: MlirOperation = .assumeOwnership(of: operation)
      /**
       The module terminator must always be at the end.
       If there is no terminator, `mlirBlockGetTerminator` returns `NULL` which causes `mlirBlockInsertOwnedOperationBefore` to act like `mlirBlockAppendOwnedOperation`.
       */
      mlirBlockInsertOwnedOperationBefore(c, mlirBlockGetTerminator(c), ownedOperation)
      let borrowedOperation: Operation = .borrow(ownedOperation)!
      return borrowedOperation
    }

    var first: MlirOperation { mlirBlockGetFirstOperation(c) }
    static var next: (MlirOperation) -> MlirOperation { mlirOperationGetNextInBlock }
    fileprivate let c: MlirBlock
  }
  public var operations: Operations { Operations(c: .borrow(self)) }

  init(storage: BridgingStorage<MlirBlock, Ownership>) { self.storage = storage }
  let storage: BridgingStorage<MlirBlock, Ownership>
}

// MARK: - Bridging

extension MlirBlock: Bridged, Destroyable, CEquatable {
  static let destroy = mlirBlockDestroy
  static let areEqual = mlirBlockEqual
  static let isNull = mlirBlockIsNull
}
