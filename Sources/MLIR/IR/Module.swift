
import CMLIR

public final class Module<MLIR: MLIRConfiguration>: MlirStructWrapper, MLIRConfigurable {
    public typealias Block = MLIR.Block
    public typealias Operation = MLIR.Operation
    
    public convenience init(parsing source: String) throws {
        try self.init(isNull: mlirModuleIsNull) {
            source.withUnsafeMlirStringRef { mlirModuleCreateParse(MLIR.context.c, $0) }
        }
    }
    public init(
        operations: [Owned<Operation>],
        file: StaticString = #file, line: Int = #line, column: Int = #column
    ) {
        let location = MLIR.location(file: file, line: line, column: column)
        c =  mlirModuleCreateEmpty(location.c)
        operations.forEach(body.append)
    }
    deinit {
        mlirModuleDestroy(c)
    }
    public var body: Block {
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
