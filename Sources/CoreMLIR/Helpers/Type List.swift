
/**
 `TypeList` provides a limited implementation of variadic generics for MLIR types. It enables the creation of a `Values` object which represents values of the types the represented by this `TypeList`. Under the hood, we just provide initializer for up to N types, similar to how the standard library does for Tuples. 
 */
public struct TypeList<MLIR: MLIRConfiguration, Values, Members: MemberCollection>
where
  Members.Index == Int,
  Members.Element  == Value
{
  let types: [MLIR.`Type`]
  func values(from base: Members.Base) -> Values {
    getValues(base)
  }
  private let getValues: (Members.Base) -> Values
}
public extension TypeList where Values == Void {
  static var none: Self { Self() }
  init() {
    types = []
    getValues = { _ in () }
  }
}

public extension TypeList {
  init(_ t0: Type<MLIR>) where Values == Value {
    types = [t0]
    getValues = { base in
      let values = base[keyPath: Members.keyPath]
      return values[0]
    }
  }
  init<T0: TypeClass>(
    _ t0: T0.Type)
  where
    T0.MLIR == MLIR,
    Values == TypedValue<T0>
  {
    types = [t0.type]
    getValues = { base in
      let values = base[keyPath: Members.keyPath]
      return TypedValue(value: values[0])
    }
  }
  init(
    _ t0: Type<MLIR>,
    _ t1: Type<MLIR>)
  where Values == (Value, Value)
  {
    types = [t0, t1]
    getValues = { base in
      let values = base[keyPath: Members.keyPath]
      return (values[0], values[1])
    }
  }
  init<T0: TypeClass, T1: TypeClass>(
    _ t0: T0.Type,
    _ t1: T1.Type)
  where
    T0.MLIR == MLIR,
    T1.MLIR == MLIR,
    Values == (TypedValue<T0>, TypedValue<T1>)
  {
    types = [t0.type, t1.type]
    getValues = { base in
      let values = base[keyPath: Members.keyPath]
      return (TypedValue(value: values[0]), TypedValue(value: values[1]))
    }
  }
  init(
    _ t0: Type<MLIR>,
    _ t1: Type<MLIR>,
    _ t2: Type<MLIR>)
  where
  Values == (Value, Value, Value)
  {
    types = [t0, t1, t2]
    getValues = { base in
      let values = base[keyPath: Members.keyPath]
      return (values[0], values[1], values[2])
    }
  }
  init<T0: TypeClass, T1: TypeClass, T2: TypeClass>(_ t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type)
  where
    T0.MLIR == MLIR,
    T1.MLIR == MLIR,
    T2.MLIR == MLIR,
    Values == (TypedValue<T0>, TypedValue<T1>, TypedValue<T2>)
  {
    types = [t0.type, t1.type, t2.type]
    getValues = { base in
      let values = base[keyPath: Members.keyPath]
      return (TypedValue(value: values[0]), TypedValue(value: values[1]), TypedValue(value: values[2]))
    }
  }
}
