
import CCoreMLIR

public extension MLIRConfiguration {
  typealias Module = CoreMLIR.Module<Self>
}

public final class Module<MLIR: MLIRConfiguration>: MlirStructWrapper, MLIRConfigurable {
  
  public convenience init(parsing source: String) throws {
    try self.init(isNull: mlirModuleIsNull) {
      source.withUnsafeMlirStringRef { mlirModuleCreateParse(MLIR.context.c, $0) }
    }
  }
  public init(
    operations buildOperations: (MLIR.Operation.Builder) throws -> Void,
    file: StaticString = #file, line: Int = #line, column: Int = #column
  ) rethrows {
    let location = MLIR.location(file: file, line: line, column: column)
    c = mlirModuleCreateEmpty(location.c)
    try MLIR.Operation.Builder
      .products(buildOperations)
      .forEach(body.prepend)
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
