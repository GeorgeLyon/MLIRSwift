
import CMLIR

public struct BlockReference: MlirStructWrapper, MlirStringCallbackStreamable, Destroyable {
    
    public static func create(with argumentTypes: [Type]) -> Owned<BlockReference> {
        let block = BlockReference(c: argumentTypes.withUnsafeMlirStructs { buffer in
            mlirBlockCreate(buffer.count, buffer.baseAddress)
        })
        return Owned.assumeOwnership(of: block)
    }
    
    public struct Operations: MlirSequence, Sequence {
        public typealias Element = OperationReference
        let firstMlirElement: MlirOperation
        static let nextMlirElement = mlirOperationGetNextInBlock
        static let mlirElementIsNull = mlirOperationIsNull
    }
    public var operations: Operations {
        Operations(firstMlirElement: mlirBlockGetFirstOperation(c))
    }
    
    mutating func append(_ operation: Owned<OperationReference>) {
        mlirBlockAppendOwnedOperation(c, operation.assumeOwnership().c)
    }
    
    func destroy() {
        mlirBlockDestroy(c)
    }
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
        mlirBlockPrint(c, unsafeCallback, userData)
    }
    
    let c: MlirBlock
}
