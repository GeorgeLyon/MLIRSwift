
import CMLIR
import CoreMLIR

public extension Dialect {
  static let scf = Dialect(
    register: mlirContextRegisterSCFDialect,
    load: mlirContextLoadSCFDialect,
    getNamespace: mlirSCFDialectGetNamespace)
}

/**
 This is a marker protocol which indicates that an `MLIRConfiguration` provides the `.scf` dialect via its `context`. The compiler does not enforce this, and it is the responsibility of the conforming type to uphold this invariant.
 */
public protocol ProvidesSCFDialect: MLIRConfiguration {
  
}
