
import CCoreMLIR

public protocol ValueProtocol {
  var value: Value { get }
}

public struct Value: MlirStructWrapper, ValueProtocol {
  public var value: Value { self }
  let c: MlirValue
}

/**
 A value associated with a `TypeClass`. This is only used to enable the Swift typechecker to reason about MLIR types.
 */
public struct TypedValue<TypeClass: CoreMLIR.TypeClass>: ValueProtocol {
  public let value: Value
}
