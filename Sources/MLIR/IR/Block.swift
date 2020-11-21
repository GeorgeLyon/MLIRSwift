
import CMLIR

public struct Block: MlirTypeWrapper {
    
    public struct Operations: MlirSequence, Sequence {
        public typealias Element = Operation
        let firstMlirElement: MlirOperation
        static let nextMlirElement = mlirOperationGetNextInBlock
        static let mlirElementIsNull = mlirOperationIsNull
    }
    public var operations: Operations {
        Operations(firstMlirElement: mlirBlockGetFirstOperation(c))
    }
    
    init(c: MlirBlock) {
        self.c = c
    }
    let c: MlirBlock
}
