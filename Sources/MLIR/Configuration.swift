
public protocol MLIRConfiguration {
  static var context: Context { get }
}

protocol MLIRConfigurable {
  associatedtype MLIR: MLIRConfiguration
}
