
import CMLIR

public struct Region<MLIR: MLIRConfiguration, Ownership: MLIR.Ownership>: OpaqueStorageRepresentable {
  public init(blocks: [MLIR.Block<OwnedBySwift>]) where Ownership == OwnedBySwift {
    self = .assumeOwnership(of: mlirRegionCreate())!
    blocks.forEach(self.blocks.append)
  }
  public init(@BlockBuilder<MLIR> blocks: () -> [BlockBuilder<MLIR>.Block]) where Ownership == OwnedBySwift {
    self.init(blocks: blocks())
  }
  
  public struct Blocks: Collection, LinkedList {
    public typealias Element = MLIR.Block<OwnedByMLIR>
    public struct Index: Comparable, OpaqueStorageRepresentable {
      let storage: LinkedListIndexStorage<MlirBlock>
      public static func <(lhs: Self, rhs: Self) -> Bool { lhs.storage < rhs.storage }
    }
    
    public func append(_ block: MLIR.Block<OwnedBySwift>) {
      mlirRegionAppendOwnedBlock(c, .assumeOwnership(of: block))
    }
    
    var first: MlirBlock { mlirRegionGetFirstBlock(c) }
    static var next: (MlirBlock) -> MlirBlock { mlirBlockGetNextInRegion }
    fileprivate let c: MlirRegion
  }
  public var blocks: Blocks { Blocks(c: .borrow(self)) }
  
  init(storage: BridgingStorage<MlirRegion, Ownership>) { self.storage = storage }
  let storage: BridgingStorage<MlirRegion, Ownership>
}

// MARK: - Building Regions

@_functionBuilder
public struct RegionBuilder<MLIR: MLIRConfiguration> {
  public typealias Region = MLIR.Region<OwnedBySwift>
  public static func buildBlock(_ components: Region...) -> [Region] { components }
}

// MARK: - Bridging

extension MlirRegion: Bridged, Destroyable {
  static let destroy = mlirRegionDestroy
  static let isNull = mlirRegionIsNull
}
