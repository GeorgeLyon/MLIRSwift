import CSCF
import MLIR

extension Dialect {
  public static let scf = Dialect(
    load: mlirContextLoadSCFDialect,
    getNamespace: mlirSCFDialectGetNamespace)
}
