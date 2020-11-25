
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
    
    func append(_ block: Owned<BlockReference>) {
        mlirRegionAppendOwnedBlock(c, block.releasingOwnership().c)
    }
    
    let c: MlirRegion
    
}

public extension MLIRConfiguration {
    static func region(
        blocks: [Owned<BlockReference>] = []) -> Owned<RegionReference>
    {
        let region = RegionReference(c: mlirRegionCreate())
        blocks.forEach(region.append)
        return Owned.assumingOwnership(of: region)
    }
}
