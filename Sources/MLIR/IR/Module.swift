
import CMLIR

public struct Module<MLIR: MLIRConfiguration>: MlirTypeWrapper {
    public init(parsing source: String) throws {
        c = try MLIR.parse {
            source.withUnsafeMlirStringRef { mlirModuleCreateParse(MLIR.context.c, $0) }
        }
    }
    public func destroy() {
        mlirModuleDestroy(c)
    }
    public var operation: Operation {
        Operation(c: mlirModuleGetOperation(c))
    }
    
    
    
    init(c: MlirModule) {
        self.c = c
    }
    let c: MlirModule
}
