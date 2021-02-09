/// This file was autogenerated by running `Tools/generate-boilerplate`

// 2 results
extension Operation.Definition where Results == (Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes t0: MLIR.`Type`, _ t1: MLIR.`Type`,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [t0, t1]
    self.ownedRegions = ownedRegions
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes _: Operation.InferredResultType, _: Operation.InferredResultType,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = nil
    self.ownedRegions = ownedRegions
  }

}

// 3 results
extension Operation.Definition where Results == (Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes t0: MLIR.`Type`, _ t1: MLIR.`Type`, _ t2: MLIR.`Type`,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [t0, t1, t2]
    self.ownedRegions = ownedRegions
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = nil
    self.ownedRegions = ownedRegions
  }

}

// 4 results
extension Operation.Definition where Results == (Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes t0: MLIR.`Type`, _ t1: MLIR.`Type`, _ t2: MLIR.`Type`, _ t3: MLIR.`Type`,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [t0, t1, t2, t3]
    self.ownedRegions = ownedRegions
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = nil
    self.ownedRegions = ownedRegions
  }

}

// 5 results
extension Operation.Definition where Results == (Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes t0: MLIR.`Type`, _ t1: MLIR.`Type`, _ t2: MLIR.`Type`, _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [t0, t1, t2, t3, t4]
    self.ownedRegions = ownedRegions
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = nil
    self.ownedRegions = ownedRegions
  }

}

// 6 results
extension Operation.Definition where Results == (Value, Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes t0: MLIR.`Type`, _ t1: MLIR.`Type`, _ t2: MLIR.`Type`, _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`, _ t5: MLIR.`Type`,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [t0, t1, t2, t3, t4, t5]
    self.ownedRegions = ownedRegions
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = nil
    self.ownedRegions = ownedRegions
  }

}

// 7 results
extension Operation.Definition where Results == (Value, Value, Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes t0: MLIR.`Type`, _ t1: MLIR.`Type`, _ t2: MLIR.`Type`, _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`, _ t5: MLIR.`Type`, _ t6: MLIR.`Type`,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [t0, t1, t2, t3, t4, t5, t6]
    self.ownedRegions = ownedRegions
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = nil
    self.ownedRegions = ownedRegions
  }

}

// 8 results
extension Operation.Definition
where Results == (Value, Value, Value, Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes t0: MLIR.`Type`, _ t1: MLIR.`Type`, _ t2: MLIR.`Type`, _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`, _ t5: MLIR.`Type`, _ t6: MLIR.`Type`, _ t7: MLIR.`Type`,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [t0, t1, t2, t3, t4, t5, t6, t7]
    self.ownedRegions = ownedRegions
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = nil
    self.ownedRegions = ownedRegions
  }

}

// 9 results
extension Operation.Definition
where Results == (Value, Value, Value, Value, Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes t0: MLIR.`Type`, _ t1: MLIR.`Type`, _ t2: MLIR.`Type`, _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`, _ t5: MLIR.`Type`, _ t6: MLIR.`Type`, _ t7: MLIR.`Type`, _ t8: MLIR.`Type`,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [t0, t1, t2, t3, t4, t5, t6, t7, t8]
    self.ownedRegions = ownedRegions
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = nil
    self.ownedRegions = ownedRegions
  }

}

// 10 results
extension Operation.Definition
where Results == (Value, Value, Value, Value, Value, Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes t0: MLIR.`Type`, _ t1: MLIR.`Type`, _ t2: MLIR.`Type`, _ t3: MLIR.`Type`,
    _ t4: MLIR.`Type`, _ t5: MLIR.`Type`, _ t6: MLIR.`Type`, _ t7: MLIR.`Type`, _ t8: MLIR.`Type`,
    _ t9: MLIR.`Type`,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9]
    self.ownedRegions = ownedRegions
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: NamedAttributes = [:],
    operands: [Value] = [],
    resultTypes _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    _: Operation.InferredResultType, _: Operation.InferredResultType,
    ownedRegions: [Region] = []
  ) {
    self.dialect = dialect
    self.name = name
    self.attributes = attributes
    self.operands = operands
    self.resultTypes = nil
    self.ownedRegions = ownedRegions
  }

}
