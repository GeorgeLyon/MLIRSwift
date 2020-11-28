
import CCoreMLIR

public struct Value: MlirStructWrapper {
  let c: MlirValue
}

public struct TypedValue<TypeClass: CoreMLIR.TypeClass> {
  let value: Value
}
