
public protocol MLIRConfiguration {
  static var dialects: RegisteredDialects { get }
  static var context: Context { get }
}

protocol MLIRConfigurable {
  associatedtype MLIR: MLIRConfiguration
}
