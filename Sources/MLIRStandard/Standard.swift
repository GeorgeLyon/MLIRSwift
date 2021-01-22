import CMLIRStandard
import MLIR

/**
 This is a marker protocol which indicates that an `MLIRConfiguration` provides the `.standard` in its `dialects` array. The compiler does not enforce this, and it is the responsibility of the conforming type to uphold this invariant.
 */
public protocol ProvidesStandardDialect: MLIRConfiguration {

}

extension RegisteredDialect where MLIR: ProvidesStandardDialect {
  public static var std: RegisteredDialect {
    dialect.registeredDialect()
  }
}

private let dialect = Dialect(
  register: mlirContextRegisterStandardDialect,
  getNamespace: mlirStandardDialectGetNamespace)
