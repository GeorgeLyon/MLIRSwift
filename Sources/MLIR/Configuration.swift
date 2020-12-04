
public protocol MLIRConfiguration {
  associatedtype DialectRegistry: MLIR.DialectRegistry
  static var context: Context { get }
}

protocol MLIRConfigurable {
  associatedtype MLIR: MLIRConfiguration
}

public extension MLIRConfiguration {
  static func namespace(of registeredDialect: RegisteredDialect) -> String {
    DialectRegistry()[keyPath: registeredDialect].namespace
  }
}
