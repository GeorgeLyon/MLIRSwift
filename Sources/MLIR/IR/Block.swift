
import CMLIR

public struct BlockReference: MlirStructWrapper, MlirStringCallbackStreamable, Destroyable {
    public struct Operations: MlirSequence, Sequence {
        public typealias Element = OperationReference
        let firstMlirElement: MlirOperation
        static let nextMlirElement = mlirOperationGetNextInBlock
        static let mlirElementIsNull = mlirOperationIsNull
    }
    public var operations: Operations {
        Operations(firstMlirElement: mlirBlockGetFirstOperation(c))
    }
    
    func append(_ operation: Owned<OperationReference>) {
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

extension MLIRConfiguration {
    static func block(argumentTypes: [Type], operations: [OperationReference]) -> Owned<BlockReference> {
        let block = BlockReference(c: argumentTypes.withUnsafeMlirStructs { buffer in
            mlirBlockCreate(buffer.count, buffer.baseAddress)
        })
        return Owned.assumingOwnership(of: block)
    }
    
}
