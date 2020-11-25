
import CMLIR

public final class Module<MLIR: MLIRConfiguration>: MlirStructWrapper {
    public typealias Block = MLIR.Block
    public typealias Operation = MLIR.Operation
    
    public init(parsing source: String) throws {
        c = try MLIR.parse {
            source.withUnsafeMlirStringRef { mlirModuleCreateParse(MLIR.context.c, $0) }
        }
    }
    public init(
        file: StaticString = #file, line: Int = #line, column: Int = #column
    ) {
        let location = MLIR.location(file: file, line: line, column: column)
        c = mlirModuleCreateEmpty(location.c)
    }
    deinit {
        mlirModuleDestroy(c)
    }
    public var body: Block<MLIR> {
        Block(c: mlirModuleGetBody(c))
    }
    
    public var operation: Operation {
        Operation(c: mlirModuleGetOperation(c))
    }
     
    init(c: MlirModule) {
        self.c = c
    }
    let c: MlirModule
}
