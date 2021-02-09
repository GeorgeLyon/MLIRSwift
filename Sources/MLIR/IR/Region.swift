
import CMLIR

public struct Region: CRepresentable {
  /**
   Creates an owned region
   */
  public init(ownedBlocks: [Block] = []) {
    c = mlirRegionCreate()
    ownedBlocks.forEach(blocks.append)
  }
  
  public struct Blocks: Collection {
    public typealias Index = LinkedListIndex<Self>
    public typealias Element = Block
    public var startIndex: Index { .starting(with: mlirRegionGetFirstBlock(c)) }
    public var endIndex: Index { .end }
    public func index(after i: Index) -> Index {
      i.successor(using: mlirBlockGetNextInRegion)
    }
    
    public func append(_ ownedBlock: Block) {
      mlirRegionAppendOwnedBlock(c, ownedBlock.c)
    }
    
    fileprivate let c: MlirRegion
  }
  public var blocks: Blocks { Blocks(c: c) }
  
  let c: MlirRegion
  
  static let isNull = mlirRegionIsNull
}
