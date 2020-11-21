
import CMLIR

public struct StandardDialect: Dialect {
    public static let register = mlirContextRegisterStandardDialect
    public static let load = mlirContextLoadStandardDialect
    public static let getNamespace = mlirStandardDialectGetNamespace
    
}

public enum Standard: MLIRConfiguration {
    public static var context = Context(
        dialects: [
            StandardDialect.self
        ])
}
