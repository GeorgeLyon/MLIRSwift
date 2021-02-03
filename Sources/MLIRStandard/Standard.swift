import CMLIRStandard
import MLIR

extension Dialect {
  public static let std = Dialect(
    register: mlirContextRegisterStandardDialect,
    getNamespace: mlirStandardDialectGetNamespace)
}
