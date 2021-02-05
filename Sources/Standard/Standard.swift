import CStandard
import MLIR

extension Dialect {
  public static let std = Dialect(
    load: mlirContextLoadStandardDialect,
    getNamespace: mlirStandardDialectGetNamespace)
}
