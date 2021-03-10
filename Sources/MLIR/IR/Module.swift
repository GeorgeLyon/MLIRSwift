
import CMLIR

/**
 The top-level object which owns an IR graph
 
 This module, along with any IR it owns, is destroyed on deinitialization.
 */
public final class Module {
  
  /**
   Creates an empty module with at the specified location
   */
  public convenience init(location: Location) {
    self.init(assumingOwnershipOf: mlirModuleCreateEmpty(location.mlir))
  }
  
  /**
   Assumes ownership of an MLIR module, meaning that module will be destroyed when `self` is deinitialized
   */
  public init(assumingOwnershipOf mlir: MlirModule) {
    precondition(!mlirModuleIsNull(mlir))
    self.mlir = mlir
  }
  deinit {
    mlirModuleDestroy(mlir)
  }
  
  public let mlir: MlirModule
}
