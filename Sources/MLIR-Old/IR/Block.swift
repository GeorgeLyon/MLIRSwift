
import CMLIR

extension MLIRConfiguration {
  public typealias Block = MLIR.Block<Self>
}

// MARK: - Block

public struct Block<MLIR: MLIRConfiguration>:
  MlirStructWrapper,
  MlirStringCallbackStreamable,
  Destroyable
{
  
  public struct Operations: MlirSequence, Sequence {
    public typealias Element = MLIR.Operation
    let mlirFirstElement: MlirOperation
    static var mlirNextElement: (MlirOperation) -> MlirOperation { mlirOperationGetNextInBlock }
    static var mlirElementIsNull: (MlirOperation) -> Int32 { mlirOperationIsNull }
  }
  public var operations: Operations {
    Operations(mlirFirstElement: mlirBlockGetFirstOperation(c))
  }
  
  public struct Arguments: RandomAccessCollection {
    public let startIndex = 0
    public let endIndex: Int
    public subscript(position: Int) -> MLIR.Value {
      Value(c: mlirBlockGetArgument(block.c, position))
    }
    fileprivate init(block: Block) {
      self.block = block
      self.endIndex = mlirBlockGetNumArguments(block.c)
    }
    private let block: Block
  }
  public var arguments: Arguments {
    Arguments(block: self)
  }
  
  @_functionBuilder
  public struct Builder {
    public struct Component {
      let get: () -> Block
    }
    public func buildExpression()
    
    public init() { }
    public mutating func build(operations: Owned<[MLIR.Operation]>) {
      blocks.append(Block(argumentTypes: [], operations: operations))
    }
    public var blocks: Owned<[Block]> = Owned([])
  }
  fileprivate init(argumentTypes: [MLIR.`Type`], operations: Owned<[MLIR.Operation]>) {
    c = argumentTypes.withUnsafeMlirStructs { argumentTypes in
      mlirBlockCreate(argumentTypes.count, argumentTypes.baseAddress)
    }
  }
  
  func prepend(_ operation: MLIR.Operation) {
    mlirBlockInsertOwnedOperation(c, 0, operation.c)
  }
  func append(_ operation: MLIR.Operation) {
    mlirBlockAppendOwnedOperation(c, operation.c)
  }
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirBlockPrint(c, unsafeCallback, userData)
  }
  
  init(c: MlirBlock) {
    self.c = c
  }
  func destroy() {
    mlirBlockDestroy(c)
  }
  let c: MlirBlock
}
