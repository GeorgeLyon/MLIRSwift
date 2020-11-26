
import CMLIR

public extension Dialect {
  static let standard = Dialect(
    register: mlirContextRegisterStandardDialect,
    load: mlirContextLoadStandardDialect,
    getNamespace: mlirStandardDialectGetNamespace)
}

/**
 This is a marker protocol which indicates that an `MLIRConfiguration` provides the `.standard` dialect via its `context`.
 */
public protocol ProvidesStandardDialect: MLIRConfiguration {
  
}
