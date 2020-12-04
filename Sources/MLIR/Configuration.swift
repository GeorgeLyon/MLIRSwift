
import MLIRDialect

public extension MLIRConfiguration {
  typealias RegisteredDialect = MLIRDialect.RegisteredDialect<Self>
}

public protocol MLIRConfiguration {
  /**
   The complete set of registered dialects. When defining an `MLIRConfiguration`, the type should also conform to some number of `Provides*Dialect` protocols. These protocols should use conditional conformance to declare a static member on `RegisteredDialect` (an example of this is provided in the [Standard Dialect](../MLIRStandard/Standard.swift)).
   The developer must ensure that each of this dialects provided is present in this array.
   */
  static var dialects: [RegisteredDialect] { get }
  static var context: Context { get }
}

protocol MLIRConfigurable {
  associatedtype MLIR: MLIRConfiguration
}
