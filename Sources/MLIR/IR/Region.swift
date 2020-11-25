
import CMLIR

extension MLIRConfiguration {
    public typealias Region = MLIR.Region<Self>
}

public struct Region<MLIR: MLIRConfiguration>:
    MlirStructWrapper,
    Destroyable
{
    
    public static func create(blocks: [Owned<Block<MLIR>>] = []) -> Owned<Region> {
        let region = Region(c: mlirRegionCreate())
        blocks.forEach(region.append)
        return Owned.assumingOwnership(of: region)
    }
    public func destroy() {
        mlirRegionDestroy(c)
    }
    
    public struct Blocks: MlirSequence, Sequence {
        public typealias Element = Block<MLIR>
        let mlirFirstElement: MlirBlock
        static var mlirNextElement: (MlirBlock) -> MlirBlock { mlirBlockGetNextInRegion }
        static var mlirElementIsNull: (MlirBlock) -> Int32 { mlirBlockIsNull }
    }
    public var blocks: Blocks {
        return Blocks(mlirFirstElement: mlirRegionGetFirstBlock(c))
    }
    
    func append(_ block: Owned<Block<MLIR>>) {
        mlirRegionAppendOwnedBlock(c, block.releasingOwnership().c)
    }
    
    let c: MlirRegion
    
}
