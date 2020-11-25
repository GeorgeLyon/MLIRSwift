
import CMLIR

public final class Module<MLIR: MLIRConfiguration>: MlirStructWrapper, MlirStringCallbackStreamable {
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
    public var body: BlockReference {
        BlockReference(c: mlirModuleGetBody(c))
    }
    
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
        mlirOperationPrint(mlirModuleGetOperation(c), unsafeCallback, userData)
    }
     
    init(c: MlirModule) {
        self.c = c
    }
    let c: MlirModule
}
