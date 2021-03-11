/// This file was autogenerated by running `Tools/generate-boilerplate`

// 2 results
extension Operation where Results == (Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes t0: Type, _ t1: Type,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [t0, t1],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes _: InferredResultType, _: InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

  public var results: Results {
    let results = typeErased.results
    precondition(results.count == 2)
    return (results[0], results[1])
  }

}

// 3 results
extension Operation where Results == (Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes t0: Type, _ t1: Type, _ t2: Type,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [t0, t1, t2],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes _: InferredResultType, _: InferredResultType, _: InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

  public var results: Results {
    let results = typeErased.results
    precondition(results.count == 3)
    return (results[0], results[1], results[2])
  }

}

// 4 results
extension Operation where Results == (Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes t0: Type, _ t1: Type, _ t2: Type, _ t3: Type,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [t0, t1, t2, t3],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes _: InferredResultType, _: InferredResultType, _: InferredResultType,
    _: InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

  public var results: Results {
    let results = typeErased.results
    precondition(results.count == 4)
    return (results[0], results[1], results[2], results[3])
  }

}

// 5 results
extension Operation where Results == (Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [t0, t1, t2, t3, t4],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes _: InferredResultType, _: InferredResultType, _: InferredResultType,
    _: InferredResultType, _: InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

  public var results: Results {
    let results = typeErased.results
    precondition(results.count == 5)
    return (results[0], results[1], results[2], results[3], results[4])
  }

}

// 6 results
extension Operation where Results == (Value, Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type, _ t5: Type,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [t0, t1, t2, t3, t4, t5],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes _: InferredResultType, _: InferredResultType, _: InferredResultType,
    _: InferredResultType, _: InferredResultType, _: InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

  public var results: Results {
    let results = typeErased.results
    precondition(results.count == 6)
    return (results[0], results[1], results[2], results[3], results[4], results[5])
  }

}

// 7 results
extension Operation where Results == (Value, Value, Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type, _ t5: Type, _ t6: Type,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [t0, t1, t2, t3, t4, t5, t6],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes _: InferredResultType, _: InferredResultType, _: InferredResultType,
    _: InferredResultType, _: InferredResultType, _: InferredResultType, _: InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

  public var results: Results {
    let results = typeErased.results
    precondition(results.count == 7)
    return (results[0], results[1], results[2], results[3], results[4], results[5], results[6])
  }

}

// 8 results
extension Operation where Results == (Value, Value, Value, Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type, _ t5: Type, _ t6: Type,
    _ t7: Type,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [t0, t1, t2, t3, t4, t5, t6, t7],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes _: InferredResultType, _: InferredResultType, _: InferredResultType,
    _: InferredResultType, _: InferredResultType, _: InferredResultType, _: InferredResultType,
    _: InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

  public var results: Results {
    let results = typeErased.results
    precondition(results.count == 8)
    return (
      results[0], results[1], results[2], results[3], results[4], results[5], results[6], results[7]
    )
  }

}

// 9 results
extension Operation
where Results == (Value, Value, Value, Value, Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type, _ t5: Type, _ t6: Type,
    _ t7: Type, _ t8: Type,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [t0, t1, t2, t3, t4, t5, t6, t7, t8],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes _: InferredResultType, _: InferredResultType, _: InferredResultType,
    _: InferredResultType, _: InferredResultType, _: InferredResultType, _: InferredResultType,
    _: InferredResultType, _: InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

  public var results: Results {
    let results = typeErased.results
    precondition(results.count == 9)
    return (
      results[0], results[1], results[2], results[3], results[4], results[5], results[6],
      results[7], results[8]
    )
  }

}

// 10 results
extension Operation
where Results == (Value, Value, Value, Value, Value, Value, Value, Value, Value, Value) {

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes t0: Type, _ t1: Type, _ t2: Type, _ t3: Type, _ t4: Type, _ t5: Type, _ t6: Type,
    _ t7: Type, _ t8: Type, _ t9: Type,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9],
      ownedRegions: ownedRegions,
      location: location)
  }

  public init(
    _ dialect: Dialect, _ name: String,
    attributes: [NamedAttribute] = [],
    operands: [Value] = [],
    resultTypes _: InferredResultType, _: InferredResultType, _: InferredResultType,
    _: InferredResultType, _: InferredResultType, _: InferredResultType, _: InferredResultType,
    _: InferredResultType, _: InferredResultType, _: InferredResultType,
    ownedRegions: [Region] = [],
    location: Location
  ) {
    self.init(
      dialect: dialect,
      name: name,
      attributes: attributes,
      operands: operands,
      resultTypes: nil,
      ownedRegions: ownedRegions,
      location: location)
  }

  public var results: Results {
    let results = typeErased.results
    precondition(results.count == 10)
    return (
      results[0], results[1], results[2], results[3], results[4], results[5], results[6],
      results[7], results[8], results[9]
    )
  }

}
