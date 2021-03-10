extension OperationProtocol where Self == TypedOperation<()> {
  /**
   - precondition: `blocks` must contain at least one block
   */
  public static func function(
    _ name: String,
    returnTypes: [MLIR.`Type`] = [],
    attributes: [NamedAttribute] = [],
    blocks: [Block],
    at location: Location
  ) -> Self {
    let entryBlock = blocks.first!
    return Self(
      dialect: nil,
      name: "func",
      attributes: attributes
        + .function(name, of: entryBlock.arguments.map(\.type), to: returnTypes, in: location.context),
      operands: [],
      resultTypes: [],
      ownedRegions: [
        Region(ownedBlocks: blocks)
      ],
      location: location)
  }
}
