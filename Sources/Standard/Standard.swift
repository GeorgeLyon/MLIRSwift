import CStandard
import MLIR

extension Dialect {
  public static let std = Dialect(mlirGetDialectHooks__std__)
}
