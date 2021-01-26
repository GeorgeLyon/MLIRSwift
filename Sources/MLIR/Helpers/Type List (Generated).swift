/// This file was autogenerated by running `Tools/generate-boilerplate`

// Oops

public struct TypeList<MLIR: MLIRConfiguration, ValuesRepresentation> {
  public let types: [MLIR.`Type`]
  public func valuesRepresentation(from values: [MLIR.Value]) -> ValuesRepresentation {
    valuesRepresentationFromArray(values)
  }
  private let valuesRepresentationFromArray: ([MLIR.Value]) -> ValuesRepresentation
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`
  ) {
    types = [t0]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 0)
      return (values[0])
    }
  }
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value,
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`,
    _ t1: MLIR.`Type`
  ) {
    types = [t0, t1]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 1)
      return (values[0], values[1])
    }
  }
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value,
    MLIR.Value,
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`,
    _ t1: MLIR.`Type`,
    _ t2: MLIR.`Type`
  ) {
    types = [t0, t1, t2]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 2)
      return (values[0], values[1], values[2])
    }
  }
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`,
    _ t1: MLIR.`Type`,
    _ t2: MLIR.`Type`,
    _ t3: MLIR.`Type`
  ) {
    types = [t0, t1, t2, t3]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 3)
      return (values[0], values[1], values[2], values[3])
    }
  }
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`,
    _ t1: MLIR.`Type`,
    _ t2: MLIR.`Type`,
    _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`
  ) {
    types = [t0, t1, t2, t3, t4]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 4)
      return (values[0], values[1], values[2], values[3], values[4])
    }
  }
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`,
    _ t1: MLIR.`Type`,
    _ t2: MLIR.`Type`,
    _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`,
    _ t5: MLIR.`Type`
  ) {
    types = [t0, t1, t2, t3, t4, t5]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 5)
      return (values[0], values[1], values[2], values[3], values[4], values[5])
    }
  }
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`,
    _ t1: MLIR.`Type`,
    _ t2: MLIR.`Type`,
    _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`,
    _ t5: MLIR.`Type`,
    _ t6: MLIR.`Type`
  ) {
    types = [t0, t1, t2, t3, t4, t5, t6]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 6)
      return (values[0], values[1], values[2], values[3], values[4], values[5], values[6])
    }
  }
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`,
    _ t1: MLIR.`Type`,
    _ t2: MLIR.`Type`,
    _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`,
    _ t5: MLIR.`Type`,
    _ t6: MLIR.`Type`,
    _ t7: MLIR.`Type`
  ) {
    types = [t0, t1, t2, t3, t4, t5, t6, t7]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 7)
      return (
        values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7]
      )
    }
  }
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`,
    _ t1: MLIR.`Type`,
    _ t2: MLIR.`Type`,
    _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`,
    _ t5: MLIR.`Type`,
    _ t6: MLIR.`Type`,
    _ t7: MLIR.`Type`,
    _ t8: MLIR.`Type`
  ) {
    types = [t0, t1, t2, t3, t4, t5, t6, t7, t8]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 8)
      return (
        values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7],
        values[8]
      )
    }
  }
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`,
    _ t1: MLIR.`Type`,
    _ t2: MLIR.`Type`,
    _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`,
    _ t5: MLIR.`Type`,
    _ t6: MLIR.`Type`,
    _ t7: MLIR.`Type`,
    _ t8: MLIR.`Type`,
    _ t9: MLIR.`Type`
  ) {
    types = [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 9)
      return (
        values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7],
        values[8], values[9]
      )
    }
  }
}

extension TypeList
where
  ValuesRepresentation == (
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value,
    MLIR.Value
  )
{
  public init(
    _ t0: MLIR.`Type`,
    _ t1: MLIR.`Type`,
    _ t2: MLIR.`Type`,
    _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`,
    _ t5: MLIR.`Type`,
    _ t6: MLIR.`Type`,
    _ t7: MLIR.`Type`,
    _ t8: MLIR.`Type`,
    _ t9: MLIR.`Type`,
    _ t10: MLIR.`Type`
  ) {
    types = [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10]
    valuesRepresentationFromArray = { values in
      precondition(values.count == 10)
      return (
        values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7],
        values[8], values[9], values[10]
      )
    }
  }
}
