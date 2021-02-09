
import CMLIR

public struct Region: CRepresentable {
  /**
   Creates an owned region
   */
  public init() {
    c = mlirRegionCreate()
  }
  
  public var owningOperation: Operation? {
    Operation(c: mlirRegionGetParentOperation(c))
  }
  
  let c: MlirRegion
  
  static let isNull = mlirRegionIsNull
}
