
public protocol MLIRConfiguration {
    static var context: MLIR.Context { get }
}

protocol MLIRConfigurable {
    associatedtype MLIR: MLIRConfiguration
}
