
import CMLIR

public struct RegionReference: MlirStructWrapper, Destroyable {
    
    public func destroy() {
        mlirRegionDestroy(c)
    }
    
    public struct Blocks: MlirSequence, Sequence {
        public typealias Element = BlockReference
        let firstMlirElement: MlirBlock
        static let nextMlirElement = mlirBlockGetNextInRegion
        static let mlirElementIsNull = mlirBlockIsNull
    }
    public var blocks: Blocks {
        return Blocks(firstMlirElement: mlirRegionGetFirstBlock(c))
    }
    let c: MlirRegion
    
}
