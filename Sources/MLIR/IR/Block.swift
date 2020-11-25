
import CMLIR

extension MLIRConfiguration {
    public typealias Block = MLIR.Block<Self>
}

public struct Block<MLIR: MLIRConfiguration>:
    MlirStructWrapper,
    MlirStringCallbackStreamable,
    Destroyable
{
    public typealias Region = MLIR.Region
    public typealias Operation = MLIR.Operation
    
    public static func create<Values>(
        arguments: TypeList<MLIR, Values, Arguments>,
        operations: (Values) -> [Owned<Operation>]
    ) -> Owned<Block> {
        let block = arguments.types.withUnsafeMlirStructs {
            Block(c: mlirBlockCreate($0.count, $0.baseAddress))
        }
        for operation in operations(arguments.reify(block)) {
            block.append(operation)
        }
        return Owned.assumingOwnership(of: block)
    }
    
    public struct Operations: MlirSequence, Sequence {
        public typealias Element = Operation
        let mlirFirstElement: MlirOperation
        static var mlirNextElement: (MlirOperation) -> MlirOperation { mlirOperationGetNextInBlock }
        static var mlirElementIsNull: (MlirOperation) -> Int32 { mlirOperationIsNull }
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
    
    func append(_ operation: Owned<Operation>) {
        mlirBlockAppendOwnedOperation(c, operation.releasingOwnership().c)
    }
    func destroy() {
        mlirBlockDestroy(c)
    }
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
        mlirBlockPrint(c, unsafeCallback, userData)
    }
    
    let c: MlirBlock
}
