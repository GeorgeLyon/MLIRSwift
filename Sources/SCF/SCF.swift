import CSCF
import MLIR

extension Dialect {
  public static let scf = Dialect(
    loadHook: mlirContextLoadSCFDialect,
    getNamespace: mlirSCFDialectGetNamespace)
}
