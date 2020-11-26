
import CMLIR

public extension MLIR.MLIRConfiguration {
  typealias Module = MLIR.Module<Self>
}

public final class Module<MLIR: MLIRConfiguration>: MlirStructWrapper, MLIRConfigurable {
  
  public convenience init(parsing source: String) throws {
    try self.init(isNull: mlirModuleIsNull) {
      source.withUnsafeMlirStringRef { mlirModuleCreateParse(MLIR.context.c, $0) }
    }
  }
  public init(
    operations buildOperations: (MLIR.Operation.Builder) -> Void,
    file: StaticString = #file, line: Int = #line, column: Int = #column
  ) {
    let location = MLIR.location(file: file, line: line, column: column)
    c = mlirModuleCreateEmpty(location.c)
    MLIR.Operation.Builder
      .products(buildOperations)
      .forEach(body.append)
  }
  deinit {
    mlirModuleDestroy(c)
  }
  public var body: MLIR.Block {
    Block(c: mlirModuleGetBody(c))
  }
  
  public var operation: MLIR.Operation {
    Operation(c: mlirModuleGetOperation(c))
  }
  
  init(c: MlirModule) {
    self.c = c
  }
  let c: MlirModule
}
