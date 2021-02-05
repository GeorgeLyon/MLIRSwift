extension Module {
  public init(location: Location, _ buildOperations: (Block<OwnedByMLIR>.Operations) throws -> Void)
    rethrows
  {
    self = Module(location: location)
    try buildOperations(body.operations)
  }
}
