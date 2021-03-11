import CMLIR

/**
 An IR node which can have arguments and holds operations
 */
public struct Block: MlirRepresentable, Equatable {
  
  /**
   Creates a block with the specified argument types
   */
  public init(argumentTypes: [Type] = []) {
    self = argumentTypes.withUnsafeMlirRepresentation {
      Self(mlirBlockCreate($0.count, $0.baseAddress))
    }
  }
  
  public init(_ mlir: MlirBlock) {
    precondition(!mlirBlockIsNull(mlir))
    self.mlir = mlir
  }
  public let mlir: MlirBlock
  
  /**
   Destroys this block
   
   This block **must not** be used after `destroy` returns, doing so will lead to undefined behavior
   */
  public func destroy() {
    mlirBlockDestroy(mlir)
  }
  
  /**
   The arguments to this block
   */
  public var arguments: Arguments {
    Arguments(block: mlir)
  }
  
  /**
   The operations in this block
   */
  public var operations: Operations {
    Operations(block: mlir)
  }

  /**
   The operation that owns this block
   */
  public var owningOperation: AnyOperation? {
    Operation(checkingForNull: mlirBlockGetParentOperation(mlir))
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    mlirBlockEqual(lhs.mlir, rhs.mlir)
  }
  
}

// MARK: - Arguments

extension Block {
  public struct Arguments: RandomAccessCollection {
    public let startIndex = 0
    public var endIndex: Int { mlirBlockGetNumArguments(block) }
    public subscript(position: Int) -> MLIR.Value {
      Value(mlirBlockGetArgument(block, position))
    }
    public func append(_ type: MLIR.`Type`) -> MLIR.Value {
      Value(mlirBlockAddArgument(block, type.mlir))
    }
    fileprivate let block: MlirBlock
  }
}

// MARK: - Operations

extension Block {
  public struct Operations: Collection {
    public typealias Index = LinkedListIndex<Self>
    public typealias Element = AnyOperation
    public var startIndex: Index { .starting(with: mlirBlockGetFirstOperation(block)) }
    public var endIndex: Index { .end }
    public func index(after i: Index) -> Index {
      i.successor(using: mlirOperationGetNextInBlock)
    }

    /**
     Takes ownership of an operation and appends it to this block
     */
    public func append(_ ownedOperation: AnyOperation) {
      /**
       If present, the module terminator must always be at the end.
       If there is no terminator, `mlirBlockGetTerminator` returns null which causes `mlirBlockInsertOwnedOperationBefore` to act like `mlirBlockAppendOwnedOperation`.
       */
      mlirBlockInsertOwnedOperationBefore(block, mlirBlockGetTerminator(block), ownedOperation.mlir)
    }
    
    /**
     Appends an operation with 0 results
     */
    public func append(_ operation: Operation<()>) {
      let operation = operation.typeErased
      precondition(operation.results.count == 0)
      append(operation)
    }
    
    public let block: MlirBlock
  }
}
