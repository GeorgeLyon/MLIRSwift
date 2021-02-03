
import Utilities

let maxNumArguments = 10

<<"""
extension OperationBuilder.GenericBuilder {

"""
for numArguments in 0...maxNumArguments {
  let range = 0...numArguments
  let names = range.map { "t\($0)" }
  <<"""

  public mutating func build(
    _ dialect: Dialect,
    _ name: String,
    attributes: MLIR.NamedAttributes = [:],
    operands: [MLIR.Value] = [],
    resultTypes \(names.map { "\($0): MLIR.`Type`" }.joined(separator: ", _ ")),
    @RegionBuilder regions: () -> [RegionBuilder.Region] = { [] },
    file: StaticString = #fileID, line: Int = #line, column: Int = #column
  ) -> (\(range.map { _ in "MLIR.Value" }.joined(separator: ", "))) {
    let results = build(
      dialect, name,
      attributes: attributes,
      operands: operands,
      resultTypes: [t0],
      regions: regions,
      file: file, line: line, column: column)
    return (\(range.map { "results[\($0)]" }.joined(separator: ", ")))
  }

  """
}

<<"}"
