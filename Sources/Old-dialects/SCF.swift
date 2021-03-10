import CDialects
import MLIR

extension Dialect {
  public static let scf = Dialect(mlirGetDialectHandle__scf__())
}
