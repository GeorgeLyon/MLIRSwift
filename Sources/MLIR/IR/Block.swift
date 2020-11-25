
import CMLIR

extension MLIRConfiguration {
    public typealias Block = MLIR.Block
}

public struct Block<MLIR: MLIRConfiguration>:
    MlirStructWrapper,
    MlirStringCallbackStreamable,
    Destroyable
{
    public typealias Region = MLIR.Region
    public typealias Operation = MLIR.Operation
    
    public struct Operations: MlirSequence, Sequence {
        public typealias Element = Operation
        let mlirFirstElement: MlirOperation
        static var mlirNextElement: (MlirOperation) -> MlirOperation { mlirOperationGetNextInBlock }
        static var mlirElementIsNull: (MlirOperation) -> Int32 { mlirOperationIsNull }
    }
    public var operations: Operations {
        Operations(mlirFirstElement: mlirBlockGetFirstOperation(c))
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
