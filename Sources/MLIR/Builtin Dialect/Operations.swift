
public extension OperationBuilder {
  mutating func buildFunc(
    _ name: String,
    returning returnTypes: [MLIR.`Type`] = [],
    attributes: MLIR.NamedAttributes = [:],
    @BlockBuilder<MLIR> blocks: () throws -> [MLIR.BlockBuilder.Block],
    file: StaticString = #file, line: Int = #line, column: Int = #column) rethrows
  {
    let blocks = try blocks()
    /// `buildFunc` requires at least one `Block`. For external functions use `externalFunc` instead.
    let entryBlock = blocks.first!
    buildBuiltinOp(
      "func",
      attributes: attributes + [
        .symbolName: .string(name),
        .type: .type(.function(of: entryBlock.arguments.map(\.type), to: returnTypes))
      ],
      operands: [],
      resultTypes: [],
      regions: [Region(blocks: blocks)],
      file: file, line: line, column: column)
  }
}
