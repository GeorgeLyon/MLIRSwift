
public protocol MLIRConfiguration {
  static var dialects: RegisteredDialects { get }
  static var context: Context { get }
}

/**
 Defines types as extensions on the `MLIRConfiguration` protocol. Mainly, this is useful so you can write `MLIR.Block` and have Swift infer the value of `Ownership`, whereas you could not write `Block<MLIR, Ownership>` without explicitly specifying the ownership.
 Types which can only be owned by MLIR, like `Attribute`, are included for consistency.
 */
public extension MLIRConfiguration {
  typealias Attribute = MLIR.Attribute<Self>
  typealias Block<Ownership: MLIR.Ownership> = MLIR.Block<Self, Ownership>
  typealias BlockBuilder = MLIR.BlockBuilder<Self>
  typealias Module = MLIR.Module<Self>
  typealias NamedAttributes = MLIR.NamedAttributes<Self>
  typealias Operation<Ownership: MLIR.Ownership> = MLIR.Operation<Self, Ownership>
  typealias Region<Ownership: MLIR.Ownership> = MLIR.Region<Self, Ownership>
  typealias `Type` = MLIR.`Type`<Self>
  typealias Value = MLIR.Value<Self>
}

protocol MLIRConfigurable {
  associatedtype MLIR: MLIRConfiguration
}
