
public struct Func<MLIR: MLIRConfiguration>: OperationProtocol {
  
  public init(
    _ name: String,
    attributes immutableAttributes: MLIR.NamedAttributes = [:],
    resultTypes: [MLIR.`Type`] = [],
    entryBlock: MLIR.Block<OwnedBySwift>,
    @Block<MLIR, OwnedBySwift>.Builder blocks: () -> [MLIR.Block<OwnedBySwift>] = { [] })
  {
    let argumentTypes = entryBlock.arguments.map(\.type)
    var attributes = immutableAttributes
    attributes.append(.symbolName, .string(name))
    attributes.append(.type, .type(.function(of: argumentTypes, to: resultTypes)))
    self.attributes = attributes
    self.resultTypes = resultTypes
    self.regions = [
      Region(blocks: [entryBlock] + blocks())
    ]
  }
  
  /**
   We believe eventually "func" will belong to a dialect, but for now it is treated special because "std.func" doesn't resolve.
   */
  public var dialect: MLIR.RegisteredDialect { fatalError() }
  public let name = "func"
  public let attributes: MLIR.NamedAttributes
  public let regions: [MLIR.Region<OwnedBySwift>]
  public let resultTypes: [MLIR.`Type`]
  public typealias Results = ()
}
