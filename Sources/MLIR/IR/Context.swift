
import CMLIR
import MLIRDialect

public extension MLIRConfiguration {
  typealias Context = MLIR.Context<Self>
}

public struct Context<MLIR: MLIRConfiguration>: MlirStructWrapper {
  public init() {
    c = mlirContextCreate()
    
    for dialect in MLIR.dialects {
      DialectMetadata.of(dialect).register(c)
    }
  }
  public func destroy() { mlirContextDestroy(c) }
  init(c: MlirContext) {
    self.c = c
  }
  public let c: MlirContext
  
}

