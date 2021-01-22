public protocol MLIRConfiguration {
  static var dialects: RegisteredDialects { get }
  static var context: Context { get }
}

/**
 Defines types as extensions on the `MLIRConfiguration` protocol. Mainly, this is useful so you can write `MLIR.Block` and have Swift infer the value of `Ownership`, whereas you could not write `Block<MLIR, Ownership>` without explicitly specifying the ownership.
 Types which can only be owned by MLIR, like `Attribute`, are included for consistency.
 */
extension MLIRConfiguration {
  public typealias Attribute = MLIR.Attribute<Self>
  public typealias Block<Ownership: MLIR.Ownership> = MLIR.Block<Self, Ownership>
  public typealias BlockBuilder = MLIR.BlockBuilder<Self>
  public typealias Identifier = MLIR.Identifier<Self>
  public typealias Module = MLIR.Module<Self>
  public typealias NamedAttributes = MLIR.NamedAttributes<Self>
  public typealias Operation<Ownership: MLIR.Ownership> = MLIR.Operation<Self, Ownership>
  public typealias Region<Ownership: MLIR.Ownership> = MLIR.Region<Self, Ownership>
  public typealias `Type` = MLIR.`Type`<Self>
  public typealias Value = MLIR.Value
}

protocol MLIRConfigurable {
  associatedtype MLIR: MLIRConfiguration
}
