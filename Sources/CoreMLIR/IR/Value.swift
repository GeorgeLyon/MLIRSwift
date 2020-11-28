
import CCoreMLIR

public struct Value: MlirStructWrapper {
  let c: MlirValue
}

/**
 A value associated with a `TypeClass`. This is only used to enable the Swift typechecker to reason about MLIR types.
 */
public struct TypedValue<TypeClass: CoreMLIR.TypeClass> {
  let value: Value
}
