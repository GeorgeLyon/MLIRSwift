import CMLIR

public struct Block: CRepresentable, Printable {
  public init(argumentTypes: [Type] = []) {
    c = argumentTypes.withUnsafeCRepresentation {
      mlirBlockCreate($0.count, $0.baseAddress)
    }
  }
  public func destroy() {
    mlirBlockDestroy(c)
  }
  public var arguments: Arguments {
    Arguments(c: c)
  }
  public var operations: Operations {
    Operations(c: c)
  }

  public var owningOperation: Operation? {
    Operation(c: mlirBlockGetParentOperation(c))
  }
  public var context: Context? {
    owningOperation?.context
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    mlirBlockEqual(lhs.c, rhs.c)
  }

  let c: MlirBlock

  static let isNull = mlirBlockIsNull
  static let print = mlirBlockPrint
}

// MARK: - Arguments

extension Block {
  public struct Arguments: RandomAccessCollection {
    public let startIndex = 0
    public var endIndex: Int { mlirBlockGetNumArguments(c) }
    public subscript(position: Int) -> MLIR.Value {
      Value(c: mlirBlockGetArgument(c, position))!
    }
    public func append(_ type: MLIR.`Type`) -> MLIR.Value {
      Value(c: mlirBlockAddArgument(c, type.c))!
    }
    fileprivate let c: MlirBlock
  }
}

// MARK: - Operations

extension Block {
  public struct Operations: Collection {
    public typealias Index = LinkedListIndex<Self>
    public typealias Element = Operation
    public var startIndex: Index { .starting(with: mlirBlockGetFirstOperation(c)) }
    public var endIndex: Index { .end }
    public func index(after i: Index) -> Index {
      i.successor(using: mlirOperationGetNextInBlock)
    }

    /**
     Appends an operation and transfers ownership of that operation to this block
     */
    public func append(_ ownedOperation: Operation) {
      /**
       The module terminator must always be at the end.
       If there is no terminator, `mlirBlockGetTerminator` returns `NULL` which causes `mlirBlockInsertOwnedOperationBefore` to act like `mlirBlockAppendOwnedOperation`.
       */
      mlirBlockInsertOwnedOperationBefore(c, mlirBlockGetTerminator(c), ownedOperation.c)
    }

    /**
     Creates an operation owned by this block using the provided definition
     - parameter definition: A **valid** operation definition.
     - returns: The results of the operation
     - precondition: `definition` must be valid or this will crash
     */
    public func append(_ definition: Operation.Definition<Operation.Results>, at location: Location)
      -> Operation.Results
    {
      let operation = Operation(definition, location: location)!
      append(operation)
      return operation.results
    }

    let c: MlirBlock
  }
}
