
import CCoreMLIR

extension MLIRConfiguration {
  public typealias Region = CoreMLIR.Region<Self>
}

public struct Region<MLIR: MLIRConfiguration>:
  MlirStructWrapper,
  Destroyable
{
  
  public struct Builder: BuilderProtocol {
    public func build(blocks: (MLIR.Block.Builder) -> Void) {
      let region = Region(c: mlirRegionCreate())
      MLIR.Block.Builder
        .products(blocks)
        .forEach(region.append)
      producer.produce(region)
    }
    let producer: Producer<Region>
  }
  
  public struct Blocks: MlirSequence, Sequence {
    public typealias Element = MLIR.Block
    let mlirFirstElement: MlirBlock
    static var mlirNextElement: (MlirBlock) -> MlirBlock { mlirBlockGetNextInRegion }
    static var mlirElementIsNull: (MlirBlock) -> Bool { mlirBlockIsNull }
  }
  public var blocks: Blocks {
    return Blocks(mlirFirstElement: mlirRegionGetFirstBlock(c))
  }
  
  func destroy() {
    mlirRegionDestroy(c)
  }
  let c: MlirRegion
  
  private func append(_ block: MLIR.Block) {
    mlirRegionAppendOwnedBlock(c, block.c)
  }
}
