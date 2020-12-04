
import CMLIR

public extension MLIRConfiguration {
  typealias Context = MLIR.Context<Self>
}

public struct Context<MLIR: MLIRConfiguration>: MlirStructWrapper {
  public init() {
    c = mlirContextCreate()
    
    let dialectRegistry = MLIR.DialectRegistry()
    for keyPath in MLIR.DialectRegistry.dialects {
      let dialect = dialectRegistry[keyPath: keyPath]
      dialect.register(c)
    }
  }
  public func destroy() { mlirContextDestroy(c) }
  init(c: MlirContext) {
    self.c = c
  }
  public let c: MlirContext
  
}

