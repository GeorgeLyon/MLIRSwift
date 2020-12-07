
import CMLIR

public struct Block<Ownership>: OwnershipSemantics {
  public init(
    arguments: [Type] = [],
    operations: [Operation<OwnedBySwift>] = [])
  where Ownership == OwnedBySwift {
    let c = arguments.withUnsafeMlirStructs { arguments in
      mlirBlockCreate(arguments.count, arguments.baseAddress)
    }
    self.init(takingOwnershipOf: c)
    operations.forEach(append)
  }
  
  /**
   Transfers ownership of `operation` to MLIR,
   */
  public func append(_ operation: Operation<OwnedBySwift>) {
    mlirBlockAppendOwnedOperation(c, operation.transferOwnerhispToMLIR())
  }
  
  init(c: MlirBlock, ownership: Ownership) {
    self.c = c
    self.ownership = ownership
  }
  let c: MlirBlock
  let ownership: Ownership
}

// MARK: - Bridging

extension MlirBlock: Destroyable {
  static let destroy = mlirBlockDestroy
}

