
import CMLIR

/**
 An IR node containing blocks
 */
public struct Region: MlirRepresentable {
  
  public let mlir: MlirRegion
  
  /**
   Creates an owned region
   */
  public init(ownedBlocks: [Block] = []) {
    self.init(mlirRegionCreate())
    ownedBlocks.forEach(blocks.append)
  }

  public struct Blocks: Collection {
    public typealias Index = LinkedListIndex<Self>
    public typealias Element = Block
    public var startIndex: Index { .starting(with: mlirRegionGetFirstBlock(region)) }
    public var endIndex: Index { .end }
    public func index(after i: Index) -> Index {
      i.successor(using: mlirBlockGetNextInRegion)
    }

    public func append(_ ownedBlock: Block) {
      mlirRegionAppendOwnedBlock(region, ownedBlock.mlir)
    }

    fileprivate let region: MlirRegion
  }
  public var blocks: Blocks { Blocks(region: mlir) }
}
