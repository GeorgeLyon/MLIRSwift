
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
  
  public struct Operations: Collection {
    public let startIndex: Index
    public var endIndex: Index { Index(value: nil) }
    public func index(after i: Index) -> Index {
      guard let value = i.value else { return endIndex }
      let operation = mlirOperationGetNextInBlock(value.operation)
      return Index(value: (offset: value.offset + 1, operation: operation))
    }
    public subscript(position: Index) -> Operation<OwnedByMLIR> {
      get { Operation(borrowing: position.value!.operation)! }
    }
    public struct Index: Comparable {
      public static func <(lhs: Self, rhs: Self) -> Bool {
        switch (lhs.value?.offset, rhs.value?.offset) {
        case let (lhs?, rhs?): return lhs < rhs
        case (.some, .none): return true
        default: return false
        }
      }
      public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.value?.operation == rhs.value?.operation
      }
      fileprivate let value: (offset: Int, operation: MlirOperation)?
    }
  }
  
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

