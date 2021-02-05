extension BuildableOperation where ResultTypes == () {
  public static func function(
    _ name: String,
    returning returnTypes: [MLIR.`Type`] = [],
    attributes: MLIR.NamedAttributes = [:],
    blocks: [Block<OwnedBySwift>]
  ) -> Self {
    /// `buildFunc` requires at least one `Block`. For external functions use `externalFunc` instead.
    let entryBlock = blocks.first!
    return Self(
      "func",
      attributes: attributes + [
        .symbolName: .string(name),
        .type: .type(.function(of: entryBlock.arguments.map(\.type), to: returnTypes)),
      ],
      operands: [],
      regions: [Region(blocks: blocks)])
  }
}
