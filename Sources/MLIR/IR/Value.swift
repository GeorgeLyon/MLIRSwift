
import CMLIR

public struct Value: MlirStructWrapper {
  let c: MlirValue
}

public struct TypedValue<TypeClass: MLIR.TypeClass> {
  let value: Value
}
