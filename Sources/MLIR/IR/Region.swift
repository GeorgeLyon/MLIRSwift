
import CMLIR

public struct Region: CRepresentable {
  /**
   Creates an owned region
   */
  public init() {
    c = mlirRegionCreate()
  }
  
  let c: MlirRegion
  
  static let isNull = mlirRegionIsNull
}
