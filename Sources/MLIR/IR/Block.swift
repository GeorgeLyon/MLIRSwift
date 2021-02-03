import CMLIR

public struct Block<Ownership: MLIR.Ownership>: OpaqueStorageRepresentable {
  public init(
    argumentTypes: [MLIR.`Type`] = [],
    operations: (inout OperationBuilder, Arguments) throws -> Void
  ) rethrows
  where Ownership == OwnedBySwift {
    self = argumentTypes.withUnsafeBorrowedValues {
      .assumeOwnership(of: mlirBlockCreate($0.count, $0.baseAddress))!
    }
    try OperationBuilder
      .build { try operations(&$0, arguments) }
      .forEach(self.operations.append)
  }

  public struct Arguments: RandomAccessCollection {
    public let startIndex = 0
    public var endIndex: Int { mlirBlockGetNumArguments(c) }
    public subscript(position: Int) -> MLIR.Value {
      .borrow(mlirBlockGetArgument(c, position))
    }
    public mutating func addArgument(ofType type: MLIR.`Type`) -> MLIR.Value {
      .borrow(mlirBlockAddArgument(c, .borrow(type)))
    }
    fileprivate let c: MlirBlock
  }
  public var arguments: Arguments { Arguments(c: .borrow(self)) }

  public typealias Operation = MLIR.Operation
  public struct Operations: Collection, LinkedList {
    public typealias Element = MLIR.Operation<OwnedByMLIR>
    public struct Index: Comparable, OpaqueStorageRepresentable {
      let storage: LinkedListIndexStorage<MlirOperation>
      public static func < (lhs: Self, rhs: Self) -> Bool { lhs.storage < rhs.storage }
    }

    public func prepend(_ operation: MLIR.Operation<OwnedBySwift>) {
      mlirBlockInsertOwnedOperation(c, 0, .assumeOwnership(of: operation))
    }
    public func append(_ operation: MLIR.Operation<OwnedBySwift>) {
      mlirBlockAppendOwnedOperation(c, .assumeOwnership(of: operation))
    }

    var first: MlirOperation { mlirBlockGetFirstOperation(c) }
    static var next: (MlirOperation) -> MlirOperation { mlirOperationGetNextInBlock }
    fileprivate let c: MlirBlock
  }
  public var operations: Operations { Operations(c: .borrow(self)) }

  typealias MlirStruct = MlirBlock
  init(storage: BridgingStorage<MlirBlock, Ownership>) { self.storage = storage }
  let storage: BridgingStorage<MlirBlock, Ownership>
}

// MARK: - Building Blocks

@_functionBuilder
public struct BlockBuilder {
  public typealias Block = MLIR.Block<OwnedBySwift>
  public static func buildBlock(_ components: Block...) -> [Block] { components }
}

// MARK: - Bridging

extension MlirBlock: Bridged, Destroyable, CEquatable {
  static let destroy = mlirBlockDestroy
  static let areEqual = mlirBlockEqual
  static let isNull = mlirBlockIsNull
}
