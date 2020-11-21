
import CMLIR

public struct Region: MlirTypeWrapper {
    
    public struct Blocks: MlirSequence, Sequence {
        public typealias Element = Block
        let firstMlirElement: MlirBlock
        static let nextMlirElement = mlirBlockGetNextInRegion
        static let mlirElementIsNull = mlirBlockIsNull
    }
    public var blocks: Blocks {
        return Blocks(firstMlirElement: mlirRegionGetFirstBlock(c))
    }
    let c: MlirRegion
    
}
