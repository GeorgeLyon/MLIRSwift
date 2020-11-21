
import CMLIR

public protocol Dialect {
    static var register: (MlirContext) -> Void { get }
    static var load: (MlirContext) -> MlirDialect { get }
    static var getNamespace: () -> MlirStringRef { get }
}

public extension Dialect {
    typealias Instance = _DialectInstance<Self>
}

public struct _DialectInstance<Dialect: MLIR.Dialect> {
    let c: MlirDialect
}
