
import CMLIR

public struct Block<Ownership>: Bridged {
  public init(
    arguments: [Type] = [],
    operations: [Operation<OwnedBySwift>] = [])
  where Ownership == OwnedBySwift {
    let c = arguments.withUnsafeMlirStructs { arguments in
      mlirBlockCreate(arguments.count, arguments.baseAddress)
    }
    /// `create` should never fail
    self.init(takingOwnershipOf: c)!
    operations.forEach(append)
  }
  
  public struct Operations: Collection, LinkedList {
    public typealias Element = Operation<OwnedByMLIR>
    public struct Index: LinkedListIndex {
      let cursor: LinkedListCursor<MlirOperation>
      static var next: (MlirOperation) -> MlirOperation { mlirOperationGetNextInBlock }
    }
    var first: MlirOperation { mlirBlockGetFirstOperation(c) }
    fileprivate let c: MlirBlock
  }
  public var operations: Operations { Operations(c: c) }
  
  /**
   Transfers ownership of `operation` to MLIR,
   */
  public func append(_ operation: Operation<OwnedBySwift>) {
    mlirBlockAppendOwnedOperation(c, operation.assumeOwnership())
  }
  
  typealias MlirStruct = MlirBlock
  init(storage: Storage) {
    self.storage = storage
  }
  let storage: Storage
}

// MARK: - Bridging

extension MlirBlock: Bridgable, Destroyable {
  static let destroy = mlirBlockDestroy
  static let areEqual = mlirBlockEqual
  static let isNull = mlirBlockIsNull
}

