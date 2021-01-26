
import Utilities

let maxNumArguments = 10

<<"""
public struct TypeList<MLIR: MLIRConfiguration, ValuesRepresentation> {
  public let types: [MLIR.`Type`]
  public func valuesRepresentation(from values: [MLIR.Value]) -> ValuesRepresentation {
    valuesRepresentationFromArray(values)
  }
  private let valuesRepresentationFromArray: ([MLIR.Value]) -> ValuesRepresentation
}

"""
for numArguments in 0...maxNumArguments {
  let range = 0...numArguments
  let names = range.map { "t\($0)" }
  <<"""
  extension TypeList
  where
    ValuesRepresentation == (
  \(range.map { _ in """
      MLIR.Value
  """ }.joined(separator: ",\n"))
    )
  {
    public init(
      \(names.map { "_ \($0): MLIR.`Type`" }.joined(separator: ", "))
    ) {
      types = [\(names.joined(separator: ", "))]
      valuesRepresentationFromArray = { values in
        precondition(values.count == \(numArguments))
        return (\(range.map { "values[\($0)]" }.joined(separator: ", ")))
      }
    }
  }

  """
}
decreaseIndentation()
