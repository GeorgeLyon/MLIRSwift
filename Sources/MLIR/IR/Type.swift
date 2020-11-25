
import CMLIR

public struct Type: MlirStructWrapper {
    let c: MlirType
}

public extension MLIRConfiguration {
    static func type(parsing source: String) throws -> `Type` {
        try parse {
            source.withUnsafeMlirStringRef {
                `Type`(c: mlirTypeParseGet(context.c, $0))
            }
        }
    }
}
