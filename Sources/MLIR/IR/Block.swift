
import CMLIR

extension MLIRConfiguration {
  public typealias Block = MLIR.Block<Self>
}

public struct Block<MLIR: MLIRConfiguration>:
  MlirStructWrapper,
  MlirStringCallbackStreamable,
  Destroyable
{
  
  public struct Operations: MlirSequence, Sequence {
    public typealias Element = MLIR.Operation
    let mlirFirstElement: MlirOperation
    static var mlirNextElement: (MlirOperation) -> MlirOperation { mlirOperationGetNextInBlock }
    static var mlirElementIsNull: (MlirOperation) -> Bool { mlirOperationIsNull }
  }
  public var operations: Operations {
    Operations(mlirFirstElement: mlirBlockGetFirstOperation(c))
  }
  
  public struct Arguments: MemberCollection, RandomAccessCollection {
    public static var keyPath: KeyPath<Block, Arguments> { \.arguments }
    public let startIndex = 0
    public let endIndex: Int
    public subscript(position: Int) -> Value {
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
  
  public struct Builder: BuilderProtocol {
    public func build<Values>(
      arguments: TypeList<MLIR, Values, Arguments>,
      operations body: (MLIR.Operation.Builder, Values) -> Void)
    {
      let block = arguments.types.withUnsafeMlirStructs {
        Block(c: mlirBlockCreate($0.count, $0.baseAddress))
      }
      MLIR.Operation.Builder
        .products { body($0, arguments.values(from: block)) }
        .forEach(block.append)
      producer.produce(block)
    }
    let producer: Producer<Block>
  }
  
  func append(_ operation: MLIR.Operation) {
    mlirBlockAppendOwnedOperation(c, operation.c)
  }
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirBlockPrint(c, unsafeCallback, userData)
  }
  
  func destroy() {
    mlirBlockDestroy(c)
  }
  let c: MlirBlock
}
