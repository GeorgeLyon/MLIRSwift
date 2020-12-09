
import CMLIRStandard
import MLIR

/**
 This is a marker protocol which indicates that an `MLIRConfiguration` provides the `.standard` in its `dialects` array. The compiler does not enforce this, and it is the responsibility of the conforming type to uphold this invariant.
 */
public protocol ProvidesStandardDialect: MLIRConfiguration {
  
}

public extension RegisteredDialect where MLIR: ProvidesStandardDialect {
  static var standard: RegisteredDialect {
    std.registeredDialect()
  }
}

let std = Dialect(
  register: mlirContextRegisterStandardDialect,
  load: mlirContextLoadStandardDialect,
  getNamespace: mlirStandardDialectGetNamespace)

