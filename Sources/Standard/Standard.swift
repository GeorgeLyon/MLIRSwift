import CStandard
import MLIR

extension Dialect {
  public static let std = Dialect(
    loadHook: mlirContextLoadStandardDialect,
    getNamespace: mlirStandardDialectGetNamespace)
}
