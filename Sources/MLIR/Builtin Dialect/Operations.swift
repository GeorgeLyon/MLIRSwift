
extension Operation.Definition where Results == () {
  /**
   - precondition: `blocks` must contain at least one block
   */
  public static func function(
    _ name: String,
    returnTypes: [MLIR.`Type`] = [],
    attributes: [NamedAttribute] = [],
    blocks: [Block],
    in context: Context) -> Self
  {
    let entryBlock = blocks.first!
    return Self(
      builtin: "func",
      attributes: attributes + [
        .symbolName(name, in: context),
        .type(.function(
                of: entryBlock.arguments.map(\.type),
                to: returnTypes, in: context))
      ],
      ownedRegions: [
        Region(ownedBlocks: blocks)
      ])
  }
}
