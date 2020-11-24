
import CMLIR

public struct Block: MlirTypeWrapper, MlirStringCallbackStreamable {
    
    public struct Operations: MlirSequence, Sequence {
        public typealias Element = Operation
        let firstMlirElement: MlirOperation
        static let nextMlirElement = mlirOperationGetNextInBlock
        static let mlirElementIsNull = mlirOperationIsNull
    }
    public var operations: Operations {
        Operations(firstMlirElement: mlirBlockGetFirstOperation(c))
    }
    
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
        mlirBlockPrint(c, unsafeCallback, userData)
    }
    
    init(c: MlirBlock) {
        self.c = c
    }
    let c: MlirBlock
}
