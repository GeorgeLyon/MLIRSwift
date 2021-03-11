extension Operation where Results == () {
  /**
   - precondition: `blocks` must contain at least one block
   */
  public static func function(
    _ name: String,
    returnTypes: [MLIR.`Type`] = [],
    attributes: [ContextualNamedAttribute] = [],
    blocks: [Block],
    at location: Location
  ) -> Self {
    let entryBlock = blocks.first!

    var attributes = attributes

    /// These will hopefully be able to use dot syntax as Swift 5.4 matures
    attributes.append(SymbolNameNamedAttribute.symbolName(name))
    attributes.append(
      TypeNamedAttribute.type(
        FunctionType.function(of: entryBlock.arguments.map(\.type), to: returnTypes)))

    return Self(
      builtin: "func",
      attributes: attributes,
      operands: [],
      resultTypes: [],
      ownedRegions: [
        Region(ownedBlocks: blocks)
      ],
      location: location)
  }
}
